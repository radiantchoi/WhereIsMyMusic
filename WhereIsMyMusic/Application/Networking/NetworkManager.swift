//
//  MelonAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/08.
//

import Foundation

struct NetworkManager {
    static let shared = NetworkManager()
}

extension NetworkManager {
    @discardableResult
    func call<T: Codable>(_ endPoint: EndPoint, for model: T.Type, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask {
        let url = endPoint.baseURL.withQueries(endPoint.query)
        var request = URLRequest(url: url!)
        request.httpMethod = endPoint.httpMethod?.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                  let model = try? JSONDecoder().decode(model, from: data) else {
                      if let error = error {
                          completion(.failure(error))
                      } else {
                          completion(.failure(UnknownNetworkError()))
                      }
                      return
                  }
            completion(.success(model))
        }
        task.resume()
        return task
    }
}

struct UnknownNetworkError: Error {
    
}
