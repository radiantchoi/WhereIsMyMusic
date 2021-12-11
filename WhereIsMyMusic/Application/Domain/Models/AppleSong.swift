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
    
    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case artist = "artistName"
        case album = "collectionName"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: CodingKeys.title)
        artist = try values.decode(String.self, forKey: CodingKeys.artist)
        album = try values.decode(String.self, forKey: CodingKeys.album)
    }
}

struct AppleSongs: Codable {
    let results: [AppleSong]
}
