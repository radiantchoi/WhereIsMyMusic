//
//  SearchResultViewViewModel.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2022/01/11.
//

import Foundation

struct SearchResultViewViewModel {
    let shazamCell: ShazamResultTableViewCellViewModel
    var songs = Box([SearchResultTableViewCellViewModel]())
    
    init(shazamCell: ShazamResultTableViewCellViewModel) {
        self.shazamCell = shazamCell
    }
}

extension SearchResultViewViewModel {
    func setSongData() {        
        let session = ParsingSession()
        session.getSongs(shazamCell.shazamSong) { parsedSongs in
            self.songs.value.append(contentsOf: parsedSongs)
        }
    }
}

