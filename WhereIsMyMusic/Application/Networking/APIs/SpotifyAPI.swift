//
//  SpotifyAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/23.
//

import Foundation

struct SpotifyAPI {
    let baseURL = URL(string: "https://api.spotify.com/v1/search")!
    var query: Query = [:]
    let accessToken: String
}

extension SpotifyAPI {
    func loadSpotifySong(completion: @escaping ([SpotifySong]?) -> Void) {
        let headers = ["Authorization": "Bearer " + accessToken,
                      "Content-type": "application/json"]
        let endPoint = EndPoint(baseURL: baseURL, httpMethod: .get, query: query, headers: headers)
        NetworkManager.shared.call(endPoint, for: SpotifyResponse.self) {
            switch $0 {
            case .success(let result):
                var spotifySongs = [SpotifySong]()
                let spotifyResults = Array(result.list)
                if spotifyResults.count < 3 {
                    for i in 0..<spotifyResults.count {
                        let spotifySong = SpotifySong(spotifySongModel: spotifyResults[i])
                        spotifySongs.append(spotifySong)
                    }
                } else {
                    for n in 0...2 {
                        let spotifySong = SpotifySong(spotifySongModel: spotifyResults[n])
                        spotifySongs.append(spotifySong)
                    }
                }
                completion(spotifySongs)
            case .failure(_):
                completion(nil)
            }
        }
    }
}
