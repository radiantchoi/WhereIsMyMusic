//
//  FloSong.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/14.
//

import Foundation

struct FloSong {
    let title: String
    let artist: String
    let album: String
    
    init(floSongModel: FloSongModel) {
        self.title = floSongModel.name
        self.album = floSongModel.album.title
        self.artist = floSongModel.artistList[0].name
    }
}
