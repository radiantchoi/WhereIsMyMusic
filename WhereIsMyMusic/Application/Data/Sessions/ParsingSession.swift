//
//  ParsingSession.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/12/12.
//

import Foundation
import RxSwift

class ParsingSession {
    private let disposeBag = DisposeBag()
}

extension ParsingSession {
    func getSongs(_ shazamSong: ShazamSong) -> Observable<[SearchResultTableViewCellViewModel]> {
        
        let searchQuery = shazamSong.title!
        let artist = shazamSong.artist!
        
        let apple = AppleAPI.init(query: ["term": searchQuery, "country": "KR"])
        let flo = FloAPI.init(query: ["keyword": searchQuery])
        let melon = MelonAPI.init(query: ["q": searchQuery])
        let genie = GenieAPI.init(query: ["query": searchQuery])
        let bugs = BugsAPI.init(query: ["q": searchQuery])
        
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
        
        return PublishSubject.create { observer in
            let appleCells = apple.loadApple()
                .subscribe(onNext: { appleSongs in
                    let cellViewModels = appleSongs.compactMap { SearchResultTableViewCellViewModel(song: Song(appleSong: $0)) }
                    observer.onNext(cellViewModels)
                })
            
            let youtubeCells = youTube.loadYouTube()
                .subscribe(onNext: { youtubeSongs in
                    let cellViewModels = youtubeSongs.compactMap { SearchResultTableViewCellViewModel(song: Song(youTubeSong: $0)) }
                    observer.onNext(cellViewModels)
                })
            
            let floCells = flo.loadFlo()
                .subscribe(onNext: { floSongs in
                    let cellViewModels = floSongs.compactMap { SearchResultTableViewCellViewModel(song: Song(floSong: $0)) }
                    observer.onNext(cellViewModels)
                })
            
            let melonCells = melon.loadMelon()
                .subscribe(onNext: { melonSongs in
                    let cellViewModels = melonSongs.compactMap { SearchResultTableViewCellViewModel(song: Song(melonSong: $0)) }
                    observer.onNext(cellViewModels)
                })
            
            let genieCells = genie.loadGenie()
                .subscribe(onNext: { genieSongs in
                    let cellViewModels = genieSongs.compactMap { SearchResultTableViewCellViewModel(song: Song(genieSong: $0)) }
                    observer.onNext(cellViewModels)
                })
            
            let bugsCells = bugs.loadBugs()
                .subscribe(onNext: { bugsSongs in
                    let cellViewModels = bugsSongs.compactMap { SearchResultTableViewCellViewModel(song: Song(bugsSong: $0)) }
                    observer.onNext(cellViewModels)
                })
            
            return Disposables.create {
                appleCells.disposed(by: self.disposeBag)
                youtubeCells.disposed(by: self.disposeBag)
                floCells.disposed(by: self.disposeBag)
                melonCells.disposed(by: self.disposeBag)
                genieCells.disposed(by: self.disposeBag)
                bugsCells.disposed(by: self.disposeBag)
            }
        }
    }
}
