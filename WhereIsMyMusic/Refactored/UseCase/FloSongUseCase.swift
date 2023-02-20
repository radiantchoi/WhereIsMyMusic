//
//  FloSongUseCase.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2023/02/21.
//

import Foundation

import RxSwift

protocol FloSongUseCase {
    func loadFloSongs(_ endpoint: Endpoint) -> Single<[FloSong]>
}

final class FloSongUseCaseImpl: FloSongUseCase {
    private let repository: SearchMusicRepository
    
    init(repository: SearchMusicRepository = SearchMusicRepositoryImpl()) {
        self.repository = repository
    }
    
    func loadFloSongs(_ endpoint: Endpoint) -> Single<[FloSong]> {
        let floResponse: Single<FloResponse> = repository.callFromAPI(endpoint)
        
        return floResponse
            .map { floResponse in
                let floResults = floResponse.data.list
                let floResult = floResults[0]
                let floSongs = floResult.list.slice(first: 3)
                
                return floSongs.compactMap { FloSong(floSongModel: $0) }
            }
    }
}
