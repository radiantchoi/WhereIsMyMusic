//
//  FloAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/16.
//

import Foundation

struct FloAPI {
    let baseURL = URL(string: "https://www.music-flo.com/api/search/v2/search")!
    var query: Query = [:]
}

extension FloAPI {
    func loadFloSong(completion: @escaping ([FloSong]?) -> Void) {
        let endPoint = EndPoint(baseURL: baseURL, query: query, httpMethod: .get)
        NetworkManager.shared.call(endPoint, for: FloResponse.self) {
            switch $0 {
            case .success(let result):
                var floSongs = [FloSong]()
                for n in 0...2 {
                    let floSong = FloSong(floSongModel: result.data.list[0].list[n])
                    floSongs.append(floSong)
                }
                print(floSongs)
            case .failure(let error):
                print(error)
            }
        }
    }
}
