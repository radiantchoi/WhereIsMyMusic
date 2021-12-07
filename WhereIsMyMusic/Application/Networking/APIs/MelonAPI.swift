//
//  MelonAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/08.
//

import Foundation

struct MelonAPI {
    private let baseURL = BaseURL.melon
    private let cssQuery = CrawlingCSS.melon.cssQuery
    private let titleCss = CrawlingCSS.melon.titleCss
    private let artistCss = CrawlingCSS.melon.artistCss
    private let albumCss = CrawlingCSS.melon.albumCss
    
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
                    let melonSong = MelonSong.init(title: data[0], artist: data[1], album: data[2])
                    melonSongs.append(melonSong)
                }
                completion(melonSongs)
            case .failure(_):
                completion(nil)
            }
        }
    }
}
