//
//  SHMediaItem+Extension.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/12/07.
//

import Foundation
import ShazamKit

extension SHMediaItemProperty {
    static let album = SHMediaItemProperty("sh_albumName")
}

extension SHMediaItem {
    var album: String? {
        return self[.album] as? String
    }
}
