//
//  GenieAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/13.
//

import Foundation
import RxSwift

struct GenieAPI {
    private let baseURL = BaseURL.genie
    private let cssQuery = ScrapingCSS.genie.cssQuery
    private let titleCss = ScrapingCSS.genie.titleCss
    private let artistCss = ScrapingCSS.genie.artistCss
    private let albumCss = ScrapingCSS.genie.albumCss
    
    var query: Query
    
    private let disposeBag = DisposeBag()
}

extension GenieAPI {
    func loadGenie() -> Observable<[GenieSong]> {
        let endPoint = EndPoint(baseURL: baseURL, httpMethod: .GET, query: query, headers: nil)
        
        return PublishSubject.create { observer in
            let source = CrawlManager.shared.crawl(endPoint, crawlingCss: ScrapingCSS.genie)
                .subscribe(onNext: { datas in
                    let genieSongs = datas.compactMap { GenieSong.init(title: $0[0], artist: $0[1], album: $0[2]) }
                    observer.onNext(genieSongs)
                })
            
            return Disposables.create {
                source.disposed(by: disposeBag)
            }
        }
    }
}
