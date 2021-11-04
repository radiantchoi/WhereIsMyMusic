//
//  CrawlManager.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/12.
//

import Foundation
import Alamofire
import SwiftSoup

struct CrawlManager {
    static let shared = CrawlManager()
}

extension CrawlManager {
    func crawl(_ endPoint: EndPoint, cssQuery: String, titleCss: [String], artistCss: [String], albumCss: [String], completion: @escaping (Result<[[String]], Error>) -> Void) {
        let url = endPoint.baseURL.withQueries(endPoint.query ?? [:])
        let urlString = String(describing: url!)
        
        AF.request(urlString)
            .responseString { (response) in
                guard let html = response.value
                else { return }
                
                do {
                    var results: [[String]] = Array(repeating: [], count: 3)
                    let doc: Document = try SwiftSoup.parse(html)
                    let elements: Elements = try doc.select(cssQuery)
                    for n in 0...2 {
                        let titleResult = try elements.select(titleCss[n]).text()
                        let artistResult = try elements.select(artistCss[n]).text()
                        let albumResult = try elements.select(albumCss[n]).text()
                        results[n].append(titleResult)
                        results[n].append(artistResult)
                        results[n].append(albumResult)
                    }
                    
                    completion(.success(results))
                } catch {
                    completion(.failure(error))
                }
            }
    }
}
