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
                var youTubeSongs = [YouTubeSong]()
                let youTubeResults = Array(result.items)
                if youTubeResults.count < 3 {
                    for i in 0..<youTubeResults.count {
                        let youTubeSong = YouTubeSong(result: youTubeResults[i])
                        youTubeSongs.append(youTubeSong)
                    }
                } else {
                    for n in 0...2 {
                        let youTubeSong = YouTubeSong(result: youTubeResults[n])
                        youTubeSongs.append(youTubeSong)
                    }
                }
                completion(youTubeSongs)
            case .failure(_):
                completion(nil)
            }
        }
    }
}
