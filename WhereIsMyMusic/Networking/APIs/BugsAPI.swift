//
//  BugsAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/14.
//

import Foundation
import RxSwift

struct BugsAPI {
    private let baseURL = BaseURL.bugs
    private let cssQuery = CrawlingCSS.bugs.cssQuery
    private let titleCss = CrawlingCSS.bugs.titleCss
    private let artistCss = CrawlingCSS.bugs.artistCss
    private let albumCss = CrawlingCSS.bugs.albumCss
    
    var query: Query
    
    private let disposeBag = DisposeBag()
}

extension BugsAPI {
    func loadBugs() -> Observable<[BugsSong]> {
        let endPoint = EndPoint(baseURL: baseURL, httpMethod: .get, query: query, headers: nil)
        
        return PublishSubject.create { observer in
            let source = CrawlManager.shared.crawl(endPoint, crawlingCss: CrawlingCSS.bugs)
                .subscribe(onNext: { datas in
                    let bugsSongs = datas.compactMap { BugsSong.init(title: $0[0], artist: $0[1], album: $0[2]) }
                    observer.onNext(bugsSongs)
                })
            
            return Disposables.create {
                source.disposed(by: disposeBag)
            }
        }
    }
}
