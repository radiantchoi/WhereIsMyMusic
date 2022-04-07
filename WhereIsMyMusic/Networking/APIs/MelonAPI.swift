//
//  MelonAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/08.
//

import Foundation
import RxSwift

struct MelonAPI {
    private let baseURL = BaseURL.melon
    private let cssQuery = CrawlingCSS.melon.cssQuery
    private let titleCss = CrawlingCSS.melon.titleCss
    private let artistCss = CrawlingCSS.melon.artistCss
    private let albumCss = CrawlingCSS.melon.albumCss
    
    var query: Query
    
    let disposeBag = DisposeBag()
}

extension MelonAPI {
    func loadMelon() -> Observable<[MelonSong]> {
        let endPoint = EndPoint(baseURL: baseURL, httpMethod: .get, query: query, headers: nil)
        
        return Observable.create { observer in
            let source = CrawlManager.shared.crawlTwo(endPoint, crawlingCss: CrawlingCSS.melon)
                .subscribe(onNext: { datas in
                    let melonSongs = datas.compactMap { MelonSong.init(title: $0[0], artist: $0[1], album: $0[2]) }
                    observer.onNext(melonSongs)
                })
            
            return Disposables.create {
                source.disposed(by: disposeBag)
            }
        }
    }
}
