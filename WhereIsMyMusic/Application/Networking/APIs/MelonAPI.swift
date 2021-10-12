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
    let titleCss = "tr:nth-child(1) > td:nth-child(3)"
    let artistCss = "tr:nth-child(1) > td:nth-child(4)"
    let albumCss = "tr:nth-child(1) > td:nth-child(5)"
    var query: Query = [:]
}

extension MelonAPI {
    func loadSong() {
        CrawlManager.shared.crawl(EndPoint(baseURL: baseURL,
                                           query: query,
                                           httpMethod: nil),
                                  cssQuery: cssQuery,
                                  titleQuery: titleCss,
                                  artistQuery: artistCss,
                                  albumQuery: albumCss) {
            switch $0 {
            case .success(let data):
                let melonSong = MelonSong.init(title: data[0], artist: data[1], album: data[2], imageURL: nil)
                print(melonSong)
            case .failure(let error):
                print(error)
            }
        }
    }
}



