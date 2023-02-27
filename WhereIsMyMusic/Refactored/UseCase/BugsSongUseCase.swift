//
//  BugsSongUseCase.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2023/02/21.
//

import Foundation

import RxSwift

protocol BugsSongUseCase {
    func loadBugsSong(_ endpoint: Endpoint) -> Single<[Song]>
}

final class BugsSongUseCaseImpl: BugsSongUseCase {
    private let repository: SearchMusicRepository
    
    init(repository: SearchMusicRepository = SearchMusicRepositoryImpl()) {
        self.repository = repository
    }
    
    func loadBugsSong(_ endpoint: Endpoint) -> Single<[Song]> {
        return repository.scrapFromWebsite(endpoint, css: ScrapingCSS.bugs)
            .map { datas in
                let bugsSongs = datas.compactMap { BugsSong.init(title: $0[0], artist: $0[1], album: $0[2]) }
                return bugsSongs.compactMap { Song(bugsSong: $0) }
            }
    }
}
