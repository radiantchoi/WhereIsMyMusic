//
//  GenieSong.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/13.
//

import Foundation

struct GenieSong: Codable {
    let title: String
    let artist: String
    let album: String
    
    init(title: String, artist: String, album: String, imageURL: URL?) {
        self.title = title
        self.artist = artist
        self.album = album
    }
}
