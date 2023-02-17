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
//    func subscribeShazamResult() -> Observable<ShazamSong>
//    func subscribeShazamError() -> Observable<ShazamError>
}

final class ShazamSearchRepositoryImpl: ShazamSearchRepository {
    private let shazamSession: ShazamSession
    
    init(shazamSession: ShazamSession = ShazamSession()) {
        self.shazamSession = shazamSession
    }
    
    func startSearching() {
        
    }
    
    func stopSearching() {
        
    }
}
