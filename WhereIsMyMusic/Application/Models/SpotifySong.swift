//
//  SpotifySong.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/23.
//

import Foundation

// Not used now

struct SpotifySong {
    let title: String
    let artist: String
    let album: String
    
    init(spotifySongModel: SpotifySongModel) {
        title = spotifySongModel.name
        artist = spotifySongModel.artists[0].name
        album = spotifySongModel.album.name
    }
}
