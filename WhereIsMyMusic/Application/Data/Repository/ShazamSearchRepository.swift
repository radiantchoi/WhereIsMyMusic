//
//  ShazamSearchRepository.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2023/02/17.
//

import RxSwift

protocol ShazamSearchRepository {
    func startSearching()
    func stopSearching()
    func subscribeShazamResult() -> Observable<ShazamSong>
    func subscribeShazamError() -> Observable<ShazamError>
    func subscribeSearchingStatus() -> Observable<Bool>
}

final class ShazamSearchRepositoryImpl: ShazamSearchRepository {
    private let shazamSession: ShazamSession
    
    init(shazamSession: ShazamSession = ShazamSession()) {
        self.shazamSession = shazamSession
    }
    
    func startSearching() {
        shazamSession.start()
    }
    
    func stopSearching() {
        shazamSession.stop()
    }
    
    func subscribeShazamResult() -> Observable<ShazamSong> {
        return shazamSession.shazamResultObservable
    }
    
    func subscribeShazamError() -> Observable<ShazamError> {
        return shazamSession.shazamErrorObservable
    }
    
    func subscribeSearchingStatus() -> Observable<Bool> {
        return shazamSession.isSearchingObservable
    }
}
