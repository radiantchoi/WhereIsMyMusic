//
//  MelonSong.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/08.
//

import Foundation

struct MelonSong: Decodable {
    let title: String?
    let artist: String?
    let album: String?
    let imageURL: URL?

    enum UnwrappingKeys: String, CodingKey {
        case contents = "SONGCONTENTS"
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "SONGNAME"
        case artist = "ARTISTNAME"
        case album = "ALBUMNAME"
        case imageURL = "ALBUMIMG"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: UnwrappingKeys.self)
        let additionalInfo = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .contents)
        self.title = try additionalInfo.decode(String.self, forKey: .title)
        self.artist = try additionalInfo.decode(String.self, forKey: .artist)
        self.album = try additionalInfo.decode(String.self, forKey: .album)
        self.imageURL = try additionalInfo.decode(URL.self, forKey: .imageURL)
    }
}

