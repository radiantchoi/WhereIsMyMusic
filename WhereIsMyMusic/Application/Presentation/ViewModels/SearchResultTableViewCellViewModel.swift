//
//  SearchResultTableViewCellViewModel.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2022/01/13.
//

import Foundation

struct SearchResultTableViewCellViewModel: Equatable {
    private let song: Song
    
    init?(song: Song?) {
        guard let song = song
        else { return nil }
        
        self.song = song
    }
}

extension SearchResultTableViewCellViewModel {
    var vendor: String? {
        return song.vendor
    }
    
    var title: String? {
        return song.title
    }
    
    var artist: String? {
        return song.artist
    }
    
    var album: String? {
        return song.album
    }
}
