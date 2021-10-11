//
//  MelonSong.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/08.
//

import Foundation

struct MelonSong: Codable {
    let title: String
    let artist: String
    let album: String
    let imageURL: URL

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
        var additionalInfo = try values.nestedUnkeyedContainer(forKey: .contents)
        
        var titles = [String]()
        var artists = [String]()
        var albums = [String]()
        var imageURLs = [URL]() 
        
        while !additionalInfo.isAtEnd {
            let contentsContainer = try additionalInfo.nestedContainer(keyedBy: CodingKeys.self)
            titles.append(try contentsContainer.decode(String.self, forKey: .title))
            artists.append(try contentsContainer.decode(String.self, forKey: .artist))
            albums.append(try contentsContainer.decode(String.self, forKey: .album))
            imageURLs.append(try contentsContainer.decode(URL.self, forKey: .imageURL))
        }
        
        guard let title = titles.first,
              let artist = artists.first,
              let album = albums.first,
              let imageURL = imageURLs.first else {
                  throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: additionalInfo.codingPath + [UnwrappingKeys.contents], debugDescription: "Initializing Error"))
              } 
        
        self.title = title
        self.artist = artist
        self.album = album
        self.imageURL = imageURL
    }
}

