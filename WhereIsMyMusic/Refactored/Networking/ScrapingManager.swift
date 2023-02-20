//
//  ScrapingManager.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2023/02/20.
//

import Foundation

import Alamofire
import RxSwift
import SwiftSoup

struct ScrapingManager {
    static let shared = ScrapingManager()
    
    private init() {}
    
    func scrap(_ endpoint: Endpoint, css: ScrapingCSS) -> Single<[[String]]> {
        guard let request = try? endpoint.toURLRequest() else {
            return Single.error(NetworkError.failedToCreateRequest)
        }
        
        return scrap(request, css: css)
    }
    
    private func scrap(_ request: URLRequest, css: ScrapingCSS) -> Single<[[String]]> {
        return Single.create { observer in
            let scrapRequest = AF.request(request)
                .validate(statusCode: 200...299)
                .responseString { response in
                    guard let html = response.value else { return }
                    
                    var results: [[String]] = []
                    do {
                        let doc = try SwiftSoup.parse(html)
                        let elements = try doc.select(css.cssQuery)
                        for n in 0...2 {
                            let titleResult = try? elements.select(css.titleCss[n]).text()
                            let artistResult = try? elements.select(css.artistCss[n]).text()
                            let albumResult = try? elements.select(css.albumCss[n]).text()
                            
                            let result = [titleResult?.replacingOccurrences(of: "TITLE", with: "") ?? "", artistResult ?? "", albumResult ?? ""]
                            results.append(result)
                        }
                    } catch {
                        observer(.failure(NetworkError.failedToGetData))
                    }
                    
                    observer(.success(results))
                }
            
            return Disposables.create {
                scrapRequest.cancel()
            }
        }
    }
}
