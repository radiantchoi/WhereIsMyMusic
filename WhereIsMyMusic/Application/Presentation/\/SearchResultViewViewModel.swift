//
//  SearchResultViewViewModel.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2022/01/11.
//

import Foundation

final class SearchResultViewViewModel {
    let shazamSong: ShazamSong
    var songs: [Song] = .init()
    
    init(shazamSong: ShazamSong) {
        self.shazamSong = shazamSong
        setSongData()
    }
}

extension SearchResultViewViewModel {
    func setSongData() {
        let session = ParsingSession()
        session.getSongs(shazamSong) { parsedSongs in
            self.songs.append(contentsOf: parsedSongs)
        }
    }
}
