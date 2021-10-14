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
        let endPoint = EndPoint(baseURL: baseURL, query: query, httpMethod: .get)
        NetworkManager.shared.call(endPoint, for: AppleSongs.self) {
            switch $0 {
            case .success(let appleSongs):
                print(appleSongs.results[0...2])
            case .failure(let error):
                print(error)
            }
        }
    }
}
