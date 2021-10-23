//
//  AppleAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/14.
//

import Foundation

struct AppleAPI {
    let baseURL = URL(string: "https://itunes.apple.com/search")!
    var query: Query = [:]
}

extension AppleAPI {
    func loadAppleSong(completion: @escaping ([AppleSong]?) -> Void) {
        let endPoint = EndPoint(baseURL: baseURL, httpMethod: .get, query: query, headers: nil)
        NetworkManager.shared.call(endPoint, for: AppleSongs.self) {
            switch $0 {
            case .success(let responses):
                let appleResults = Array(responses.results)
                if appleResults.count < 3 {
                    completion(appleResults)
                } else {
                    completion(Array(appleResults[0...2]))
                }
            case .failure(_):
                completion(nil)
            }
        }
    }
}
