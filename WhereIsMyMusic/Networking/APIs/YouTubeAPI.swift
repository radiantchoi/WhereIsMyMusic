//
//  YouTubeAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/17.
//

import Foundation
import RxSwift

struct YouTubeAPI {
    private let baseURL = BaseURL.youTube
    var query: Query
    
    private let disposeBag = DisposeBag()
}

extension YouTubeAPI {
    func loadYouTube() -> Observable<[YouTubeSong]> {
        let endPoint = EndPoint(baseURL: baseURL, httpMethod: .GET, query: query, headers: nil)
        
        return PublishSubject.create { observer in
            let data = NetworkManager.shared.call(endPoint, for: YouTubeResponse.self)
                .subscribe(onNext: { youtubeSongs in
                    let youtubeResult = youtubeSongs.items.slice(first: 3)
                    let youtubeData = youtubeResult.compactMap { YouTubeSong(result: $0) }
                    observer.onNext(youtubeData)
                })
            
            return Disposables.create {
                data.disposed(by: disposeBag)
            }
        }
    }
}
