//
//  VibeSongModel.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/21.
//

import Foundation

struct VibeSongModel {
    var trackTitle: String
    var artistName: String
    var albumTitle: String
}

enum XMLKey: String {
    case trackTitle, artistName, albumTitle
}
