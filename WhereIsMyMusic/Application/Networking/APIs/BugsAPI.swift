//
//  BugsAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/14.
//

import Foundation

struct BugsAPI {
    let baseURL = URL(string: "https://music.bugs.co.kr/search/track")!
    let cssQuery = "#DEFAULT0 > table > tbody"
    let titleCss = ["tr:nth-child(1) > th > p > a",
                    "tr:nth-child(2) > th > p > a",
                    "tr:nth-child(3) > th > p > a"]
    let artistCss = ["tr:nth-child(1) > td:nth-child(7) > p > a",
                     "tr:nth-child(2) > td:nth-child(7) > p > a",
                     "tr:nth-child(3) > td:nth-child(7) > p > a"]
    let albumCss = ["tr:nth-child(1) > td:nth-child(8) > a",
                    "tr:nth-child(2) > td:nth-child(8) > a",
                    "tr:nth-child(3) > td:nth-child(8) > a"]
    var query: Query = [:]
}

extension BugsAPI {
    func loadBugsSong(completion: @escaping ([BugsSong]?) -> Void) {

        CrawlManager.shared.crawl(EndPoint(baseURL: baseURL,
                                           query: query,
                                           httpMethod: nil),
                                  cssQuery: cssQuery,
                                  titleCss: titleCss,
                                  artistCss: artistCss,
                                  albumCss: albumCss) {
            switch $0 {
            case .success(let datas):
                var bugsSongs = [BugsSong]()
                for data in datas {
                    let bugsSong = BugsSong.init(title: data[0], artist: data[1], album: data[2], imageURL: nil)
                    bugsSongs.append(bugsSong)
                }
                completion(bugsSongs)
            case .failure(_):
                completion(nil)
            }
        }
    }
}
