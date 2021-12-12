//
//  BugsAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/14.
//

import Foundation

struct BugsAPI {
    private let baseURL = BaseURL.bugs
    private let cssQuery = CrawlingCSS.bugs.cssQuery
    private let titleCss = CrawlingCSS.bugs.titleCss
    private let artistCss = CrawlingCSS.bugs.artistCss
    private let albumCss = CrawlingCSS.bugs.albumCss
    
    var query: Query = [:]
}

extension BugsAPI {
    func loadBugsSong(completion: @escaping ([BugsSong]?) -> Void) {

        CrawlManager.shared.crawl(EndPoint(baseURL: baseURL,
                                           httpMethod: .get,
                                           query: query,
                                           headers: nil),
                                  crawlingCss: CrawlingCSS.bugs) {
            switch $0 {
            case .success(let datas):
                var bugsSongs = [BugsSong]()
                for data in datas {
                    let bugsSong = BugsSong.init(title: data[0], artist: data[1], album: data[2])
                    bugsSongs.append(bugsSong)
                }
                completion(bugsSongs)
            case .failure(_):
                completion(nil)
            }
        }
    }
}
