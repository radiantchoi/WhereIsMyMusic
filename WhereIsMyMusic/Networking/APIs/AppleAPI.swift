//
//  AppleAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/14.
//

import Foundation
import RxSwift

struct AppleAPI {
    private let baseURL = BaseURL.apple
    var query: Query
    
    let disposeBag = DisposeBag()
}

extension AppleAPI {
    func loadApple() -> Observable<[AppleSong]> {
        let endPoint = EndPoint(baseURL: baseURL, httpMethod: .get, query: query, headers: nil)
        
        return Observable<[AppleSong]>.create { observer in
            let data = NetworkManager.shared.call(endPoint, for: AppleSongs.self)
                .subscribe(onNext: { appleSongs in
                    let appleResult = appleSongs.results.slice(first: 3)
                    let appleData = appleResult.compactMap { AppleSong(appleSongModel: $0) }
                    observer.onNext(appleData)
                })
            
            return Disposables.create {
                data.disposed(by: disposeBag)
            }
        }
    }
    
}

