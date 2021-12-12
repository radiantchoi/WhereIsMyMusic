//
//  GenieAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/13.
//

import Foundation

struct GenieAPI {
    private let baseURL = BaseURL.genie
    private let cssQuery = CrawlingCSS.genie.cssQuery
    private let titleCss = CrawlingCSS.genie.titleCss
    private let artistCss = CrawlingCSS.genie.artistCss
    private let albumCss = CrawlingCSS.genie.albumCss
    
    var query: Query
}

extension GenieAPI {
    func loadGenieSong(completion: @escaping ([GenieSong]?) -> Void) {

        CrawlManager.shared.crawl(EndPoint(baseURL: baseURL,
                                           httpMethod: .get,
                                           query: query,
                                           headers: nil),
                                  crawlingCss: CrawlingCSS.genie) {
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
                    let genieSong = GenieSong.init(title: titleData, artist: data[1], album: data[2])
                    genieSongs.append(genieSong)
                }
                completion(genieSongs)
                
            case .failure(_):
                completion(nil)
            }
        }
    }
}
