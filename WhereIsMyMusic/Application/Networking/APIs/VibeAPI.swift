//
//  VibeAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/21.
//

import Foundation

struct VibeAPI {
    let baseURL = URL(string: "https://apis.naver.com/vibeWeb/musicapiweb/v3/search/track")!
    var query: Query = [:]
    
}

extension VibeAPI {
    
    func loadVibeSong(completion: @escaping (VibeSong?) -> Void) {
        let parsingSession = ParsingSession(url: baseURL.withQueries(query)!)
        parsingSession.completion = {
            switch $0 {
            case .success(let vibeSongModel):
                let vibeSong = VibeSong(vibeSongModel: vibeSongModel)
                completion(vibeSong)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
        parsingSession.start()
//        var vibeSongs = [VibeSong]()
//        for n in 0...2 {
//            let vibeSong = VibeSong(vibeSongModel: parsingSession.tracks[n])
//            vibeSongs.append(vibeSong)
//        }
        
//        completion(vibeSongs)
    }
    
}


