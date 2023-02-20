//
//  BugsSongUseCase.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2023/02/21.
//

import Foundation

import RxSwift

protocol BugsSongUseCase {
    func loadBugsSong(_ endpoint: Endpoint) -> Single<[BugsSong]>
}

final class BugsSongUseCaseImpl: BugsSongUseCase {
    private let repository: SearchMusicRepository
    
    init(repository: SearchMusicRepository = SearchMusicRepositoryImpl()) {
        self.repository = repository
    }
    
    func loadBugsSong(_ endpoint: Endpoint) -> Single<[BugsSong]> {
        return repository.scrapFromWebsite(endpoint, css: ScrapingCSS.bugs)
            .map { datas in
                return datas.compactMap { BugsSong.init(title: $0[0], artist: $0[1], album: $0[2]) }
            }
    }
}
