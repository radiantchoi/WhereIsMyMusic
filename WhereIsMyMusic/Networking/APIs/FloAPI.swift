//
//  FloAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/16.
//

import Foundation
import RxSwift

struct FloAPI {
    private let baseURL = BaseURL.flo
    var query: Query
    
    private let disposeBag = DisposeBag()
}

extension FloAPI {
    func loadFlo() -> Observable<[FloSong]> {
        let endPoint = EndPoint(baseURL: baseURL, httpMethod: .get, query: query, headers: nil)
        
        return PublishSubject.create { observer in
            let data = NetworkManager.shared.call(endPoint, for: FloResponse.self)
                .subscribe(onNext: { floSongs in
                    let floResults = floSongs.data.list[0].list.slice(first: 3)
                    let floData = floResults.compactMap { FloSong(floSongModel: $0) }
                    observer.onNext(floData)
                })
            
            return Disposables.create {
                data.disposed(by: disposeBag)
            }
        }
    }
}
