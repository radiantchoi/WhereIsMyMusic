//
//  VibeAPI.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/21.
//

import Foundation
import Alamofire

struct VibeAPI {
    let baseURL = URL(string: "https://apis.naver.com/vibeWeb/musicapiweb/v3/search/track")!
    var query: Query = [:]
}

extension VibeAPI {
    
    func loadVibeSong(completion: @escaping (VibeSong?) -> Void) {
        let parsingSession = ParsingSession()
        parsingSession.start(baseUrl: baseURL, query: query)
        // 문제부분 - completion에 결과가 넘어오지 않는다. 에러조차도 뜨지 않는다.
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
    }
    
}


