//
//  SearchResultViewViewModel.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2022/01/11.
//

import Foundation
import RxSwift
import RxRelay

struct SearchResultViewViewModel {
    let shazamCell: ShazamResultTableViewCellViewModel
    let songs: BehaviorRelay<[SearchResultTableViewCellViewModel]> = BehaviorRelay(value: [])
    
    let disposeBag = DisposeBag()
    
    init(shazamCell: ShazamResultTableViewCellViewModel) {
        self.shazamCell = shazamCell
    }
}

extension SearchResultViewViewModel {
    func setSongData() {        
        let session = ParsingSession()
        session.getSongs(shazamCell.shazamSong) { parsedSongs in
            let newValue = self.songs.value + parsedSongs
            self.songs.accept(newValue)
        }
        
        session.getSongsTwo(shazamCell.shazamSong)
            .subscribe(onNext: { viewModels in
                let newValue = self.songs.value + viewModels
                self.songs.accept(newValue)
            }).disposed(by: disposeBag)
    }
}

