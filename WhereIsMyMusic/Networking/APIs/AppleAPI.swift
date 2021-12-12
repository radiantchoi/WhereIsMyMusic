//
//  AppleAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/14.
//

import Foundation

struct AppleAPI {
    private let baseURL = BaseURL.apple
    var query: Query = [:]
}

extension AppleAPI {
    func loadAppleSong(completion: @escaping ([AppleSong]?) -> Void) {
        let endPoint = EndPoint(baseURL: baseURL, httpMethod: .get, query: query, headers: nil)
        NetworkManager.shared.call(endPoint, for: AppleSongs.self) {
            switch $0 {
            case .success(let responses):
                let appleResults = Array(responses.results)
                let appleSongs = appleResults.slice(first: 3)
                completion(appleSongs)
            case .failure(_):
                completion(nil)
            }
        }
    }
}
