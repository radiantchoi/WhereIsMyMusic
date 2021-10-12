//
//  MelonAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/08.
//

import Foundation

struct MelonAPI {
    let baseURL = URL(string: "https://www.melon.com/search/song/index.htm")!
    let cssQuery = "#frm_defaultList > div > table > tbody"
    let titleCss = "tr:nth-child(1) > td:nth-child(3) > div > div > a.fc_gray"
    let artistCss = "#artistName > a"
    let albumCss = "tr:nth-child(1) > td:nth-child(5) > div > div > a"
    var query: Query = [:]
}

extension MelonAPI {
    func loadMelonSong(completion: @escaping (MelonSong?) -> Void) {

        CrawlManager.shared.crawl(EndPoint(baseURL: baseURL,
                                           query: query,
                                           httpMethod: nil),
                                  cssQuery: cssQuery,
                                  titleCss: titleCss,
                                  artistCss: artistCss,
                                  albumCss: albumCss) {
            switch $0 {
            case .success(let data):
                let melonSong = MelonSong.init(title: data[0], artist: data[1], album: data[2], imageURL: nil)
                completion(melonSong)
            case .failure(_):
                completion(nil)
            }
        }
    }
}
