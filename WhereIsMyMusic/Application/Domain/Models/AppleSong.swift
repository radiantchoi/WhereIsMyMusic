//
//  AppleSong.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/14.
//

import Foundation

struct AppleSong: Codable {
    let title: String
    let artist: String
    let album: String
    
    init(appleSongModel: AppleSongModel) {
        self.title = appleSongModel.trackName
        self.artist = appleSongModel.artistName
        self.album = appleSongModel.collectionName
    }
}


