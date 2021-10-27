//
//  BugsSong.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/14.
//

import Foundation

struct BugsSong: Codable {
    let title: String
    let artist: String
    let album: String
    
    init(title: String, artist: String, album: String) {
        self.title = title
        self.artist = artist
        self.album = album
    }
}
