//
//  Song.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/27.
//

import Foundation

struct Song {
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
    init?(melonSong: MelonSong) {
        guard melonSong.title.isEmpty == false,
              melonSong.artist.isEmpty == false,
              melonSong.album.isEmpty == false
        else { return nil }
        
        self.init(vendor: "Melon",
                  title: melonSong.title,
                  artist: melonSong.artist,
                  album: melonSong.album
        )
    }
    
    init?(genieSong: GenieSong) {
        guard genieSong.title.isEmpty == false,
              genieSong.artist.isEmpty == false,
              genieSong.album.isEmpty == false
        else { return nil }
        
        self.init(vendor: "Genie",
                  title: genieSong.title,
                  artist: genieSong.artist,
                  album: genieSong.album
        )
    }
    
    init?(bugsSong: BugsSong) {
        guard bugsSong.title.isEmpty == false,
              bugsSong.artist.isEmpty == false,
              bugsSong.album.isEmpty == false
        else { return nil }
        
        self.init(vendor: "Bugs",
                  title: bugsSong.title,
                  artist: bugsSong.artist,
                  album: bugsSong.album
        )
    }
    
    init(appleSong: AppleSong) {
        self.init(vendor: "Apple",
                  title: appleSong.title,
                  artist: appleSong.artist,
                  album: appleSong.album)
    }
    
    init(floSong: FloSong) {
        self.init(vendor: "Flo",
                  title: floSong.title,
                  artist: floSong.artist,
                  album: floSong.album)
    }
    
    init(youTubeSong: YouTubeSong) {
        self.init(vendor: "YouTube",
                  title: youTubeSong.title,
                  artist: youTubeSong.channel,
                  album: "")
    }
}
