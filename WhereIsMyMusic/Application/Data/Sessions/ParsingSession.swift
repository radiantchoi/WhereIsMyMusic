//
//  ParsingSession.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/12/12.
//

import Foundation

class ParsingSession {
    func getSongs(_ shazamSong: ShazamSong, completion: @escaping ([SearchResultTableViewCellViewModel]) -> Void) {
        
        guard let title = shazamSong.title,
              let artist = shazamSong.artist,
              let _ = shazamSong.album
        else { return }
        
        let searchQuery = title
        
        let melon = MelonAPI.init(query: ["q": searchQuery])
        melon.loadMelonSong { (result) in
            guard let result = result
            else { return }
            
            let songs = result.compactMap { SearchResultTableViewCellViewModel(song: Song(melonSong: $0)) }
            completion(songs)
        }
        
        let genie = GenieAPI.init(query: ["query": searchQuery])
        genie.loadGenieSong{ (result) in
            guard let result = result
            else { return }
            
            let songs = result.compactMap { SearchResultTableViewCellViewModel(song: Song(genieSong: $0)) }
            completion(songs)
        }
        
        let bugs = BugsAPI.init(query: ["q": searchQuery])
        bugs.loadBugsSong { (result) in
            guard let result = result
            else { return }
            
            let songs = result.compactMap { SearchResultTableViewCellViewModel(song: Song(bugsSong: $0)) }
            completion(songs)
        }
        
        let apple = AppleAPI.init(query: ["term": searchQuery, "country": "KR"])
        apple.loadAppleSong { (result) in
            guard let result = result
            else { return }
            
            let songs = result.compactMap { SearchResultTableViewCellViewModel(song: Song(appleSong: $0)) }
            completion(songs)
        }
        
        let appleArray = apple.loadApple()
            .subscribe(onNext: {
                print($0)
            })
        
        
        let flo = FloAPI.init(query: ["keyword": searchQuery])
        flo.loadFloSong { (result) in
            guard let result = result
            else { return }
            
            let songs = result.compactMap { SearchResultTableViewCellViewModel(song: Song(floSong: $0)) }
            completion(songs)
        }
        
        var apiKey: String {
            get {
                guard let filePath = Bundle.main.path(forResource: "Keys", ofType: "plist")
                else {
                    fatalError("Couldn't find Keys.plist file")
                }
                
                let plist = NSDictionary(contentsOfFile: filePath)
                guard let value = plist?.object(forKey: "YOUTUBE_API_KEY") as? String
                else {
                    fatalError("Couldn't find 'YOUTUBE_API_KEY' in 'Keys.plist'.")
                }
                return value
            }
        }
        
        let youTube = YouTubeAPI.init(query: ["q": searchQuery + " " + artist,
                                              "type": "video",
                                              "videoCategoryId": "10",
                                              "part": "snippet",
                                              "maxResult": "10",
                                              "key": apiKey]
        )
        youTube.loadYoutubeSong { (result) in
            guard let result = result
            else { return }
            
            let songs = result.compactMap { SearchResultTableViewCellViewModel(song: Song(youTubeSong: $0)) }
            completion(songs)
        }
        
    }
}
