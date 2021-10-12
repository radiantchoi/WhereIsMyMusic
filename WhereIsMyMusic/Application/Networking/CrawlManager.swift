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
    func crawl(_ endPoint: EndPoint, cssQuery: String, titleQuery: String, artistQuery: String, albumQuery: String, completion: @escaping (Result<[String], Error>) -> Void) {
        let url = endPoint.baseURL.withQueries(endPoint.query)
        let urlString = String(describing: url!)
        
        AF.request(urlString)
            .responseString { (response) in
                guard let html = response.value
                else { return }
                
                do {
                    let doc: Document = try SwiftSoup.parse(html)
                    let elements: Elements = try doc.select(cssQuery)
                    let titleResult = try elements.select(titleQuery).text()
                    let artistResult = try elements.select(artistQuery).text()
                    let albumResult = try elements.select(albumQuery).text()
                    completion(.success([titleResult, artistResult, albumResult]))
                } catch {
                    print("Crawl error")
                    completion(.failure(error))
                }
            }
    }
}
