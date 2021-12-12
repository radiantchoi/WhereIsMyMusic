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
                let floResults = Array(result.data.list[0].list)
                let floSongModels = floResults.slice(first: 3)
                let floSongs = floSongModels.compactMap { FloSong(floSongModel: $0) }
                completion(floSongs)
            case .failure(_):
                completion(nil)
            }
        }
    }
}
