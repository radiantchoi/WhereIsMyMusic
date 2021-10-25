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
    let titleCss = ["tr:nth-child(1) > td:nth-child(3) > div > div > a.fc_gray",
                    "tr:nth-child(2) > td:nth-child(3) > div > div > a.fc_gray",
                    "tr:nth-child(3) > td:nth-child(3) > div > div > a.fc_gray"]
    let artistCss = ["tr:nth-child(1) > td:nth-child(4) > div > div > a",
                     "tr:nth-child(2) > td:nth-child(4) > div > div > a",
                     "tr:nth-child(3) > td:nth-child(4) > div > div > a"]
    let albumCss = ["tr:nth-child(1) > td:nth-child(5) > div > div > a",
                    "tr:nth-child(2) > td:nth-child(5) > div > div > a",
                    "tr:nth-child(3) > td:nth-child(5) > div > div > a"]
    var query: Query = [:]
}

extension MelonAPI {
    func loadMelonSong(completion: @escaping ([MelonSong]?) -> Void) {

        CrawlManager.shared.crawl(EndPoint(baseURL: baseURL,
                                           httpMethod: .get,
                                           query: query,
                                           headers: nil),
                                  cssQuery: cssQuery,
                                  titleCss: titleCss,
                                  artistCss: artistCss,
                                  albumCss: albumCss) {
            switch $0 {
            case .success(let datas):
                var melonSongs = [MelonSong]()
                for data in datas {
                    let melonSong = MelonSong.init(title: data[0], artist: data[1], album: data[2], imageURL: nil)
                    melonSongs.append(melonSong)
                }
                completion(melonSongs)
            case .failure(_):
                completion(nil)
            }
        }
    }
}
