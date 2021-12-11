//
//  BaseURL.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/12/07.
//

import Foundation

struct BaseURL {
    static let melon = URL(string: "https://www.melon.com/search/song/index.htm")!
    static let genie = URL(string: "https://www.genie.co.kr/search/searchSong")!
    static let bugs = URL(string: "https://music.bugs.co.kr/search/track")!
    static let apple = URL(string: "https://itunes.apple.com/search")!
    static let flo = URL(string: "https://www.music-flo.com/api/search/v2/search")!
    static let youTube = URL(string: "https://www.googleapis.com/youtube/v3/search")!
}
