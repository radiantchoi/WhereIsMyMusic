//
//  YouTubeAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/17.
//

import Foundation

struct YouTubeAPI {
    private let baseURL = BaseURL.youTube
    var query: Query = [:]
}

extension YouTubeAPI {
    func loadYoutubeSong(completion: @escaping ([YouTubeSong]?) -> Void) {
        let endPoint = EndPoint(baseURL: baseURL, httpMethod: .get, query: query, headers: nil)
        NetworkManager.shared.call(endPoint, for: YouTubeResponse.self) {
            switch $0 {
            case .success(let result):
                let youTubeResults = Array(result.items).slice(first: 3)
                let youTubeSongs = youTubeResults.compactMap { YouTubeSong(result: $0) }
                completion(youTubeSongs)
            case .failure(_):
                completion(nil)
            }
        }
    }
}
