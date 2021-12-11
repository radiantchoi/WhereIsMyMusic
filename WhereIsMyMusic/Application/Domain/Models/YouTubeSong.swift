//
//  YoutubeSong.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/17.
//

import Foundation

struct YouTubeSong {
    let title: String
    let channel: String
    
    init(result: YouTubeResult) {
        let ytSong = result.snippet
        title = ytSong.title
        channel = ytSong.channelTitle
    }
}
