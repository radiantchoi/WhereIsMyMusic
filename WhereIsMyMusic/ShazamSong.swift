//
//  ShazamSong.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/07.
//

import Foundation
import ShazamKit

struct ShazamSong {
    var title: String?
    var artist: String?
    var album: String?
    var imageURL: URL?
    
    init?(mediaItem: SHMediaItem?) {
        guard let mediaItem = mediaItem else {
            return nil
        }
        
        self.title = mediaItem.title
        self.artist = mediaItem.artist
        self.album = mediaItem.album
        self.imageURL = mediaItem.artworkURL
    }
}
