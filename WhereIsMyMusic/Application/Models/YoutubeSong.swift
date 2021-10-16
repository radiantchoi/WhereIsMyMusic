//
//  YoutubeSong.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/17.
//

import Foundation

struct YoutubeSong {
    let title: String
    let channel: String
    
    init(youtubeSongModel: YoutubeSongModel) {
        title = youtubeSongModel.title
        channel = youtubeSongModel.channelTitle
    }
}
