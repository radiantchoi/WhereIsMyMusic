//
//  MelonAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/08.
//

import Foundation

struct MelonAPI {
    let baseURL = URL(string: "https://www.melon.com/search/keyword/index.json")!
    var query: Query = [:]
}

extension MelonAPI {
    func loadSong() {
        NetworkManager.shared.call(EndPoint(baseURL: baseURL,
                                            query: query,
                                            httpMethod: .get),
                                   for: MelonSong.self) {
            switch $0 {
            case .success(let melonSong):
                print(melonSong)
            case .failure(let error):
                print(error)
            }
        }
    }
}



