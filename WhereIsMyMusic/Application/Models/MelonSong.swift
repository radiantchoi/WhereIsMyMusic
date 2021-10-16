//
//  MelonSong.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/08.
//

import Foundation

struct MelonSong: Codable {
    let title: String
    let artist: String
    let album: String
    
    init(title: String, artist: String, album: String, imageURL: URL?) {
        self.title = title
        self.artist = artist
        self.album = album
    }    
}

