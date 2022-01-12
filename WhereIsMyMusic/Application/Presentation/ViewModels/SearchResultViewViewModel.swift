//
//  SearchResultViewViewModel.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2022/01/11.
//

import Foundation

final class SearchResultViewViewModel {
    let shazamSong: ShazamSong
    var songs = Box([Song]())
    
    init(shazamSong: ShazamSong) {
        self.shazamSong = shazamSong
    }
}

extension SearchResultViewViewModel {
    func setSongData() {        
        let session = ParsingSession()
        session.getSongs(shazamSong) { parsedSongs in
            self.songs.value.append(contentsOf: parsedSongs)
        }
    }
}

