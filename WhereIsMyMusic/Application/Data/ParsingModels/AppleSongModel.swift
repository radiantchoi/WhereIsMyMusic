//
//  AppleSongModel.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2022/04/05.
//

import Foundation

struct AppleSongs: Codable {
    let results: [AppleSongModel]
}

struct AppleSongModel: Codable {
    let trackName: String
    let artistName: String
    let collectionName: String
}
