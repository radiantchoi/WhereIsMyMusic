//
//   YoutubeSongModel.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/17.
//

import Foundation

struct YouTubeResponse: Codable {
    let items: [YouTubeResult]
}

struct YouTubeResult: Codable {
    let snippet: YouTubeSongModel
}

struct YouTubeSongModel: Codable {
    let title: String
    let channelTitle: String
}
