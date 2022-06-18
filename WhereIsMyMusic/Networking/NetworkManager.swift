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
    func call<T: Codable>(_ endPoint: EndPoint, for model: T.Type) -> Observable<T> {
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
                    guard let data = response.data,
                          let model = try? JSONDecoder().decode(T.self, from: data)
                    else { return }
                    
                    observer.onNext(model)
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
