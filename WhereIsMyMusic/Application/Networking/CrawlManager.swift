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
    func crawl(_ endPoint: EndPoint) {
        let url = endPoint.baseURL.withQueries(endPoint.query)
        let urlString = String(describing: url!)
        
        AF.request(urlString)
            .responseString { (response) in
                guard let html = response.value
                else { return }
                
                do {
                    let doc: Document = try SwiftSoup.parse(html)
                    let elements: Elements = try doc.select("#frm_defaultList > div > table > tbody")
                    for element in elements {
                        let titleResult = try elements.select("tr:nth-child(1) > td:nth-child(3)").text()
                        let artistResult = try elements.select("tr:nth-child(1) > td:nth-child(4)").text()
                        let albumResult = try elements.select("tr:nth-child(1) > td:nth-child(5)").text()
                        print(titleResult + artistResult + albumResult) 
                    }
                } catch {
                    print("Crawl error")
                }
            }
    }
}
