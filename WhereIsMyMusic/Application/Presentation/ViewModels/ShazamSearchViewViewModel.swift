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
    var shazamSong = PublishSubject<ShazamSong>()
    var error = PublishSubject<ShazamError>()
    var searching = BehaviorSubject(value: false)
    
    init() {
        shazamSession.completion = {
            switch $0 {
            case .success(let shazamSong):
                self.searching.onNext(false)
                self.shazamSong.onNext(shazamSong)
            case .failure(let error):
                self.searching.onNext(false)
                self.error.onNext(error)
            }
        }
    }
}
