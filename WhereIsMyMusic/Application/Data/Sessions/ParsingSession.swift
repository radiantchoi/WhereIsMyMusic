//
//  ParsingSession.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/12/12.
//

import Foundation

class ParsingSession {
    func getSongs(_ shazamSong: ShazamSong, completion: @escaping (Song) -> Void) {
        
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
            for melonSong in result {
                guard let song = Song(melonSong: melonSong)
                else { return }
                completion(song)
            }
            
        }
        
        var genie = GenieAPI.init()
        genie.query = ["query": searchQuery]
        genie.loadGenieSong{ (result) in
            guard let result = result
            else { return }
            for genieSong in result {
                guard let song = Song(genieSong: genieSong)
                else { return }
                completion(song)
            }
        }
        
        var bugs = BugsAPI.init()
        bugs.query = ["q": searchQuery]
        bugs.loadBugsSong { (result) in
            guard let result = result
            else { return }
            for bugsSong in result {
                guard let song = Song(bugsSong: bugsSong)
                else { return }
                completion(song)
            }
        }
        
        var apple = AppleAPI.init()
        apple.query = ["term": searchQuery, "country": "KR"]
        apple.loadAppleSong { (result) in
            guard let result = result
            else { return }
            for appleSong in result {
                let song = Song(appleSong: appleSong)
                completion(song)
            }
        }
        
        var flo = FloAPI.init()
        flo.query = ["keyword": searchQuery]
        flo.loadFloSong { (result) in
            guard let result = result
            else { return }
            for floSong in result {
                let song = Song(floSong: floSong)
                completion(song)
            }
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
            for youTubeSong in result {
                let song = Song(youTubeSong: youTubeSong)
                completion(song)
            }
        }
        
    }
}
