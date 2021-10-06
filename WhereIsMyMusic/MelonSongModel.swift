//
//  MelonSongModel.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/09/27.
//

import Foundation

struct MelonSongModel: Codable {
    var title: String?
    var artist: String?
    var album: String?
    var imageURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case title = "SONGNAME"
        case artist = "ARTISTNAME"
        case album = "ALBUMNAME"
        case imageURL = "ALBUMIMG"
    }
}
