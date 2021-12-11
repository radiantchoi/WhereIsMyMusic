//
//  ParsingSession.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/12/12.
//

import Foundation

class ParsingSession {
    func getSongs(_ shazamSong: ShazamSong, completion: @escaping ([Song]) -> Void) {
        
        guard let title = shazamSong.title,
              let artist = shazamSong.artist,
              let _ = shazamSong.album
        else { return }
        
        let searchQuery = title
        
        var melon = MelonAPI.init()
        melon.query = ["q": searchQuery]
        melon.loadMelonSong { (result) in
            guard let result = result
            else { return }
            
            let songs = result.compactMap { Song(melonSong: $0) }
            completion(songs)
        }
        
        var genie = GenieAPI.init()
        genie.query = ["query": searchQuery]
        genie.loadGenieSong{ (result) in
            guard let result = result
            else { return }
            
            let songs = result.compactMap { Song(genieSong: $0) }
            completion(songs)
        }

        var bugs = BugsAPI.init()
        bugs.query = ["q": searchQuery]
        bugs.loadBugsSong { (result) in
            guard let result = result
            else { return }
            
            let songs = result.compactMap { Song(bugsSong: $0) }
            completion(songs)
        }

        var apple = AppleAPI.init()
        apple.query = ["term": searchQuery, "country": "KR"]
        apple.loadAppleSong { (result) in
            guard let result = result
            else { return }
            
            let songs = result.compactMap { Song(appleSong: $0) }
            completion(songs)
        }

        var flo = FloAPI.init()
        flo.query = ["keyword": searchQuery]
        flo.loadFloSong { (result) in
            guard let result = result
            else { return }
            
            let songs = result.compactMap { Song(floSong: $0) }
            completion(songs)
        }

        var youTube = YouTubeAPI.init()
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
        
        youTube.query = ["q": searchQuery + " " + artist,
                         "type": "video",
                         "videoCategoryId": "10",
                         "part": "snippet",
                         "maxResult": "10",
                         "key": apiKey]
        youTube.loadYoutubeSong { (result) in
            guard let result = result
            else { return }
            
            let songs = result.compactMap { Song(youTubeSong: $0) }
            completion(songs)
        }
        
    }
}
