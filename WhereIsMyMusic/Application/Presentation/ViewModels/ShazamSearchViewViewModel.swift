//
//  ShazamSearchViewViewModel.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2022/01/10.
//

import Foundation

class ShazamSearchViewViewModel {
    let shazamSession = ShazamSession()
    var shazamSong: Box<ShazamSong?> = Box(nil)
    var error: Box<ShazamError?> = Box(nil)
    var searching = Box(false)
    
    init() {
        shazamSession.completion = {
            switch $0 {
            case .success(let shazamSong):
                self.searching.value = false
                self.shazamSong.value = shazamSong
            case .failure(let error):
                self.searching.value = false
                self.error.value = error
            }
        }
    }
}
