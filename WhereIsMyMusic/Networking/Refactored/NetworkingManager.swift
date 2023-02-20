//
//  NetworkingManager.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2023/02/19.
//

import Foundation

import Alamofire
import RxSwift

struct NetworkingManager {
    static let shared = NetworkingManager()
    
    private init() {}
    
    func call(_ endpoint: Endpoint) -> Single<Data> {
        guard let request = try? endpoint.toURLRequest() else {
            return Single.error(NetworkError.failedToCreateRequest)
        }
        
        // 향후 업로드 태스크가 추가되면, 알맞은 세션타입을 넣어서 보강해야 함
        // 데이터 바디를 빌드해야 하기도 함
        return call(request)
    }
    
    private func call(_ request: URLRequest, sessionType: SessionType = .dataTask, data: Data? = nil) -> Single<Data> {
        return Single.create { observer in
//            let completionHandler: (Data?, URLResponse?, Error?) -> Void = { data, response, error in
//                if error != nil {
//                    observer(.failure(NetworkError.unknownNetworkError))
//                    return
//                }
//
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    observer(.failure(NetworkError.failedToGetHTTPResponse))
//                    return
//                }
//
//                guard let data else {
//                    observer(.failure(NetworkError.failedToGetData))
//                    return
//                }
//
//                if (200...299) ~= httpResponse.statusCode {
//                    observer(.success(data))
//                } else {
//                    observer(.failure(NetworkError.invalidNetworkStatusCode(code: httpResponse.statusCode)))
//                }
//            }
//
//            let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
//            task.resume()
            
//            return Disposables.create()
            
            let dataRequest = AF.request(request)
                .validate(statusCode: 200...299)
                .responseData { response in
                    guard let data else {
                        observer(.failure(NetworkError.failedToGetData))
                        return
                    }
                    
                    observer(.success(data))
                }
            
            return Disposables.create {
                dataRequest.cancel()
            }
        }
        .catch { error -> Single<Data> in
            if let afError = error as? AFError,
               let responseCode = afError.responseCode {
                return Single.error(NetworkError.invalidNetworkStatusCode(code: responseCode))
            } else {
                return Single.error(NetworkError.unknownNetworkError)
            }
        }
    }
    
    enum SessionType {
        case dataTask
        // 업로드 태스크도 향후 추가할 수 있음
    }
}
