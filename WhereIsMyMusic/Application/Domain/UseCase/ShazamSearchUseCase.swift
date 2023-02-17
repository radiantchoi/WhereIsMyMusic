//
//  ShazamSearchUseCase.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2023/02/17.
//

import RxSwift

protocol ShazamSearchUseCase {
    func startSearching()
    func stopSearching()
//    func subscribeShazamResult() -> Observable<ShazamSong>
//    func subscribeShazamError() -> Observable<ShazamError>
}

final class ShazamSearchUseCaseImpl: ShazamSearchUseCase {
    private let repository: ShazamSearchRepository
    
    init(repository: ShazamSearchRepository = ShazamSearchRepositoryImpl()) {
        self.repository = repository
    }
    
    func startSearching() {
        
    }
    
    func stopSearching() {
        
    }
}
