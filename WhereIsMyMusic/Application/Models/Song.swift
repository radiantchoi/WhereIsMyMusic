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
    
    init(melonSong: MelonSong) {
        vendor = "Melon"
        title = melonSong.title
        artist = melonSong.artist
        album = melonSong.album
    }
    
    init(genieSong: GenieSong) {
        vendor = "Genie"
        title = genieSong.title
        artist = genieSong.artist
        album = genieSong.album
    }
    
    init(bugsSong: BugsSong) {
        vendor = "Bugs"
        title = bugsSong.title
        artist = bugsSong.artist
        album = bugsSong.album
    }
    
    init(appleSong: AppleSong) {
        vendor = "Apple"
        title = appleSong.title
        artist = appleSong.artist
        album = appleSong.album
    }
    
    init(floSong: FloSong) {
        vendor = "Flo"
        title = floSong.title
        artist = floSong.artist
        album = floSong.album
    }
    
    init(youTubeSong: YouTubeSong) {
        vendor = "YouTube"
        title = youTubeSong.title
        artist = youTubeSong.channel
        album = ""
    }
}
