//
//  ShazamSearchViewViewModel.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2022/01/10.
//

import Foundation

import RxSwift

final class ShazamSearchViewViewModel {
    let shazamSong = PublishSubject<ShazamSong>()
    let shazamError = PublishSubject<ShazamError>()
    let searching = BehaviorSubject(value: false)
    
    private let shazamUseCase: ShazamSearchUseCase
    private let disposeBag = DisposeBag()
    
    init(shazamUseCase: ShazamSearchUseCase = ShazamSearchUseCaseImpl()) {
        self.shazamUseCase = shazamUseCase
        
        subscribeViewModel()
    }
    
    func startSearching() {
        shazamUseCase.startSearching()
    }
    
    func stopSearching() {
        shazamUseCase.stopSearching()
    }
    
    func subscribeViewModel() {
        shazamUseCase.subscribeShazamResult()
            .subscribe(onNext: { [weak self] result in
                self?.shazamSong.onNext(result)
            })
            .disposed(by: disposeBag)
        
        shazamUseCase.subscribeShazamError()
            .subscribe(onNext: { [weak self] error in
                self?.shazamError.onNext(error)
            })
            .disposed(by: disposeBag)
        
        shazamUseCase.subscribeSearchingStatus()
            .subscribe(onNext: { [weak self] isSearching in
                self?.searching.onNext(isSearching)
            })
            .disposed(by: disposeBag)
    }
}
