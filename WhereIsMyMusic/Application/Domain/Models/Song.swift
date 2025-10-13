//
//  Song.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/27.
//

import Foundation

struct Song: Equatable {
    let vendor: String
    let title: String
    let artist: String
    let album: String
    
    init(vendor: String, title: String, artist: String, album: String) {
        self.vendor = vendor
        self.title = title
        self.artist = artist
        self.album = album
    }
}
extension Song {
    init(appleSong: AppleSong) {
        self.init(vendor: "Apple",
                  title: appleSong.title,
                  artist: appleSong.artist,
                  album: appleSong.album)
    }

    init(youTubeSong: YouTubeSong) {
        self.init(vendor: "YouTube",
                  title: youTubeSong.title,
                  artist: youTubeSong.channel,
                  album: "")
    }
}
