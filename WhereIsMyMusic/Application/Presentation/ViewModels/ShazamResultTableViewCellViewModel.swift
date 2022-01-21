//
//  ShazamResultTableViewCellViewModel.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2022/01/13.
//

import Foundation

struct ShazamResultTableViewCellViewModel: Equatable {
    let shazamSong: ShazamSong
    
    init?(shazamSong: ShazamSong?) {
        guard let shazamSong = shazamSong
        else { return nil }
        
        self.shazamSong = shazamSong
    }
}

extension ShazamResultTableViewCellViewModel {
    var title: String? {
        return shazamSong.title
    }
    
    var artist: String? {
        return shazamSong.artist
    }
    
    var album: String? {
        return shazamSong.album
    }
    
    var imageURL: URL? {
        return shazamSong.imageURL
    }
}
