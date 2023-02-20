//
//  CrawlManager.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/12.
//

import Foundation
import Alamofire
import SwiftSoup
import RxSwift

struct CrawlManager {
    static let shared = CrawlManager()
}

extension CrawlManager {
    func crawl(_ endPoint: EndPoint, crawlingCss: ScrapingCSS) -> Observable<[[String]]> {
        let url = endPoint.baseURL.withQueries(endPoint.query ?? [:])
        let urlString = String(describing: url!)
        
        return Observable<[[String]]>.create { observer in
            let data = AF.request(urlString)
                .responseString { response in
                    guard let html = response.value
                    else { return }
                    
                    var results: [[String]] = []
                    let doc = try? SwiftSoup.parse(html)
                    let elements = try? doc?.select(crawlingCss.cssQuery)
                    for n in 0...2 {
                        let titleResult = try? elements?.select(crawlingCss.titleCss[n]).text()
                        let artistResult = try? elements?.select(crawlingCss.artistCss[n]).text()
                        let albumResult = try? elements?.select(crawlingCss.albumCss[n]).text()
                        
                        let result = [titleResult?.replacingOccurrences(of: "TITLE", with: "") ?? "", artistResult ?? "", albumResult ?? ""]
                        results.append(result)
                    }
                    
                    observer.onNext(results)
                    observer.onCompleted()
                }
            
            return Disposables.create {
                data.cancel()
            }
        }
    }
}
