//
//  VibeSong.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/21.
//

import Foundation

// Not used now

struct VibeSong {
    let title: String
    let artist: String
    let album: String
    
    init(vibeSongModel: VibeSongModel) {
        title = vibeSongModel.trackTitle
        album = vibeSongModel.albumTitle
        artist = vibeSongModel.artistName
    }
}

