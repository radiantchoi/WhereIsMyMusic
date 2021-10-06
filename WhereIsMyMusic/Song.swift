//
//  Song.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/09/27.
//

import Foundation

struct Song {
    let title: String
    let artist: String
    let album: String
    
    init?(melonSongModel: MelonSongModel?) {
        guard let melonSongModel = melonSongModel,
              let title = melonSongModel.title,
              let artist = melonSongModel.artist,
              let album = melonSongModel.album
        else { return nil }
        
        self.title = title
        self.artist = artist
        self.album = album
    }
}

extension Song: Equatable {
    static func ==(lhs: Song, rhs: Song) -> Bool {
        return lhs.title == rhs.title && lhs.artist == rhs.artist && lhs.album == rhs.album
    }
}
