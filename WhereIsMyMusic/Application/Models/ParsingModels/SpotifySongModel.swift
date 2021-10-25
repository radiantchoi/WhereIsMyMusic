//
//  SpotifySongModel.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/23.
//

import Foundation

struct SpotifyResponse: Codable {
    let list: [SpotifySongModel]
}

struct SpotifySongModel: Codable {
    let name: String
    let artists: [SpotifyArtist]
    let album: SpotifyAlbum
}

struct SpotifyArtist: Codable {
    let name: String
}

struct SpotifyAlbum: Codable {
    let name: String
}
