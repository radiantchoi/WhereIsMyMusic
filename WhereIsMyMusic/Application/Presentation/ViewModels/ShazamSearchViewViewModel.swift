//
//  ShazamSearchViewViewModel.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2022/01/10.
//

import Foundation
import RxRelay
import RxSwift

class ShazamSearchViewViewModel {
    let shazamSession = ShazamSession()
    let shazamSong = PublishSubject<ShazamSong>()
    let error = PublishSubject<ShazamError>()
    let searching = BehaviorSubject(value: false)
    
    let disposeBag = DisposeBag()
    
    init() {
//        shazamSession.completion = {
//            switch $0 {
//            case .success(let shazamSong):
//                self.searching.onNext(false)
//                self.shazamSong.onNext(shazamSong)
//            case .failure(let error):
//                self.searching.onNext(false)
//                self.error.onNext(error)
//            }
//        }
        
        shazamSession.completion.asObserver()
            .subscribe(onNext: { shazamSong in
                self.searching.onNext(false)
                self.shazamSong.onNext(shazamSong)
            }, onError: { error in
                self.searching.onNext(false)
                self.error.onNext(error as! ShazamError)
            }).disposed(by: disposeBag)
    }
}
