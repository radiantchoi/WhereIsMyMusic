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
    
    private let disposeBag = DisposeBag()
    
    init() {        
        shazamSession.completion.asObserver()
            .subscribe(onNext: { result in
//                self.searching.onNext(false)
//                self.shazamSong.onNext(shazamSong)
//            }, onError: { error in
//                self.searching.onNext(false)
//                self.error.onNext(error as! ShazamError)
                
                self.searching.onNext(false)
                switch result {
                case .success(let shazamSong):
                    self.shazamSong.onNext(shazamSong)
                case .failure(let error):
                    self.error.onNext(error)
                }
                
            }).disposed(by: disposeBag)
    }
}
