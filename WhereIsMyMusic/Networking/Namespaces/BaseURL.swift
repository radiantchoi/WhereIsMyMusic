//
//  BaseURL.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/12/07.
//

import Foundation

enum BaseURL {
    static let apple = URL(string: "https://itunes.apple.com/search")!
    static let youTube = URL(string: "https://www.googleapis.com/youtube/v3/search")!
}
