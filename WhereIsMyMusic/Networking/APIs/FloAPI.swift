//
//  FloAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/16.
//

import Foundation

struct FloAPI {
    private let baseURL = BaseURL.flo
    var query: Query = [:]
}

extension FloAPI {
    func loadFloSong(completion: @escaping ([FloSong]?) -> Void) {
        let endPoint = EndPoint(baseURL: baseURL, httpMethod: .get, query: query, headers: nil)
        NetworkManager.shared.call(endPoint, for: FloResponse.self) {
            switch $0 {
            case .success(let result):
                var floSongs = [FloSong]()
                let floResults = Array(result.data.list[0].list)
                if floResults.count < 3 {
                    for i in 0..<floResults.count {
                        let floSong = FloSong(floSongModel: floResults[i])
                        floSongs.append(floSong)
                    }
                } else {
                    for n in 0...2 {
                        let floSong = FloSong(floSongModel: floResults[n])
                        floSongs.append(floSong)
                    }
                }
                completion(floSongs)
            case .failure(_):
                completion(nil)
            }
        }
    }
}
