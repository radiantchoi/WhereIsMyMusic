//
//  FloSongModel.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/16.
//

import Foundation

struct FloResponse: Codable {
    let data: FloData
}

struct FloData: Codable {
    let list: [FloResult]
}

struct FloResult: Codable {
    let list: [FloSongModel]
}

struct FloSongModel: Codable  {
    let name: String
    let album: FloAlbum
    let artistList: [FloArtist]
}

struct FloAlbum: Codable {
    let title: String
}

struct FloArtist: Codable {
    let name: String
}
