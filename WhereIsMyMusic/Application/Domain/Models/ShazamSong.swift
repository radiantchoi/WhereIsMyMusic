//
//  ShazamSong.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/07.
//

import Foundation
import ShazamKit

struct ShazamSong: Equatable {
    let isrc: String
    let title: String
    let artist: String
    let album: String
    let imageURL: URL?
    
    init(shazamSongDTO: ShazamSongDTO) {
        isrc = shazamSongDTO.isrc
        title = shazamSongDTO.title
        artist = shazamSongDTO.artist
        album = shazamSongDTO.album
        imageURL = shazamSongDTO.imageURL
    }
}
