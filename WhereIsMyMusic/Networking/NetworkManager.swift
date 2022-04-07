//
//  MelonAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/08.
//

import Foundation
import RxSwift
import Alamofire

struct NetworkManager {
    static let shared = NetworkManager()
}

extension NetworkManager {
    @discardableResult
    func call<T: Codable>(_ endPoint: EndPoint, for model: T.Type, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask {
        let url = endPoint.baseURL.withQueries(endPoint.query ?? [:])
        var request = URLRequest(url: url!)
        request.httpMethod = endPoint.httpMethod.rawValue
        
        if endPoint.headers != nil {
            for (key, value) in endPoint.headers! {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let result: Result<T, Error>
            
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let data = data,
                  let model = try? JSONDecoder().decode(model, from: data)
            else {
                result = .failure(error ?? UnknownNetworkError())
                return
            }
            
            result = .success(model)
        }
        task.resume()
        return task
    }
    
    func callTwo<T: Codable>(_ endPoint: EndPoint, for model: T.Type) -> Observable<T> {
        let url = endPoint.baseURL.withQueries(endPoint.query ?? [:])
        var request = URLRequest(url: url!)
        request.httpMethod = endPoint.httpMethod.rawValue
        
        if endPoint.headers != nil {
            for (key, value) in endPoint.headers! {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return Observable<T>.create { observer in
            let dataRequest = AF.request(request)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let model: T = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(model)
                        } catch (let error) {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                    
                    observer.onCompleted()
                }
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
}

struct UnknownNetworkError: Error {
    
}
