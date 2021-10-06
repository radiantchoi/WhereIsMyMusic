//
//  Song.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/09/27.
//

import Foundation

struct Song {
    var title: String
    var artist: String
    var album: String
    var imageURL: URL
    
    init?(melonSongModel: MelonSongModel?) {
        guard let melonSongModel = melonSongModel,
              let title = melonSongModel.title,
              let artist = melonSongModel.artist,
              let album = melonSongModel.album,
              let imageURL = melonSongModel.imageURL
        else { return nil }
        
        self.title = title
        self.artist = artist
        self.album = album
        self.imageURL = imageURL
    }
}

extension Song: Equatable {
    static func ==(lhs: Song, rhs: Song) -> Bool {
        return lhs.title == rhs.title && lhs.artist == rhs.artist && lhs.album == rhs.album
    }
}
