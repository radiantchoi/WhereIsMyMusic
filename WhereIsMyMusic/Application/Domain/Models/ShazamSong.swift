//
//  ShazamSong.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/07.
//

import Foundation
import ShazamKit

struct ShazamSong: Equatable {
    let title: String?
    let artist: String?
    let album: String?
    let imageURL: URL?
    
    init?(mediaItem: SHMatchedMediaItem) {
        guard let title = mediaItem.title,
              let artist = mediaItem.artist,
              let album = mediaItem.album
        else { return nil }
        
        self.title = title
        self.artist = artist
        self.album = album
        self.imageURL = mediaItem.artworkURL
    }
}
