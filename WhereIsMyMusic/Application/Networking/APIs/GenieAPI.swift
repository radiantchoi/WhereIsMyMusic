//
//  GenieAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/13.
//

import Foundation

struct GenieAPI {
    let baseURL = URL(string: "https://www.genie.co.kr/search/searchSong")!
    let cssQuery = "#body-content > div.search_song > div.music-list-wrap > div.music-list-wrap > table > tbody"
    let titleCss = ["tr:nth-child(1) > td.info > a.title.ellipsis",
                    "tr:nth-child(2) > td.info > a.title.ellipsis",
                    "tr:nth-child(3) > td.info > a.title.ellipsis"]
    let artistCss = ["tr:nth-child(1) > td.info > a.artist.ellipsis",
                     "tr:nth-child(2) > td.info > a.artist.ellipsis",
                     "tr:nth-child(3) > td.info > a.artist.ellipsis"]
    let albumCss = ["tr:nth-child(1) > td.info > a.albumtitle.ellipsis",
                    "tr:nth-child(2) > td.info > a.albumtitle.ellipsis",
                    "tr:nth-child(3) > td.info > a.albumtitle.ellipsis"]
    var query: Query = [:]
}

extension GenieAPI {
    func loadGenieSong(completion: @escaping ([GenieSong]?) -> Void) {

        CrawlManager.shared.crawl(EndPoint(baseURL: baseURL,
                                           query: query,
                                           httpMethod: nil),
                                  cssQuery: cssQuery,
                                  titleCss: titleCss,
                                  artistCss: artistCss,
                                  albumCss: albumCss) {
            switch $0 {
            case .success(let datas):
                var genieSongs = [GenieSong]()
                for data in datas {
                    var titleData: String = ""
                    if data[0].count != 0 {
                        let titleSpread = data[0].map { String($0) }
                        if titleSpread.count > 6 && titleSpread[0...5].joined() == "TITLE " {
                            titleData = titleSpread[6...].joined()
                        } else {
                            titleData = titleSpread.joined()
                        }
                    }
                    let genieSong = GenieSong.init(title: titleData, artist: data[1], album: data[2], imageURL: nil)
                    genieSongs.append(genieSong)
                }
                completion(genieSongs)
                
            case .failure(_):
                completion(nil)
            }
        }
    }
}
