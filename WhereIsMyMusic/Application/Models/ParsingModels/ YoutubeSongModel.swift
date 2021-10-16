//
//   YoutubeSongModel.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/17.
//

import Foundation

struct YoutubeResponse: Codable {
    let items: [YoutubeResult]
}

struct YoutubeResult: Codable {
    let snippet: YoutubeSongModel
}

struct YoutubeSongModel: Codable {
    let title: String
    let channelTitle: String
}
