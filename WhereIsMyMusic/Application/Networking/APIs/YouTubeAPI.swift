//
//  YouTubeAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/17.
//

import Foundation

struct YouTubeAPI {
    let baseURL = URL(string: "https://www.googleapis.com/youtube/v3/search")!
    var query: Query = [:]
}

extension YouTubeAPI {
    func loadYoutubeSong(completion: @escaping ([YouTubeSong]?) -> Void) {
        let endPoint = EndPoint(baseURL: baseURL, query: query, httpMethod: .get)
        NetworkManager.shared.call(endPoint, for: YouTubeResponse.self) {
            switch $0 {
            case .success(let result):
                var youTubeSongs = [YouTubeSong]()
                let youTubeResults = Array(result.items)
                if youTubeResults.count < 3 {
                    for i in 0..<youTubeResults.count {
                        let youTubeSong = YouTubeSong(youTubeSongModel: youTubeResults[i].snippet)
                        youTubeSongs.append(youTubeSong)
                    }
                } else {
                    for n in 0...2 {
                        let youTubeSong = YouTubeSong(youTubeSongModel: youTubeResults[n].snippet)
                        youTubeSongs.append(youTubeSong)
                    }
                }
                completion(youTubeSongs)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
