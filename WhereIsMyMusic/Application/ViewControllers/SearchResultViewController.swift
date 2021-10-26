//
//  SearchResultViewController.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/07.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    private let resultTableView: UITableView = {
        let table = UITableView()
        
        table.register(ShazamResultTableViewCell.nib(),
                       forCellReuseIdentifier: ShazamResultTableViewCell.identifier)
        table.register(SearchResultTableViewCell.nib(),
                       forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        
        return table
    }()
    
    let shazamSong: ShazamSong
    var songs: [Song] = .init()
    
    init(shazamSong: ShazamSong) {
        self.shazamSong = shazamSong
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchResultViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(resultTableView)
        resultTableView.delegate = self
        resultTableView.dataSource = self
        getSongs()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resultTableView.frame = view.bounds
    }
}

extension SearchResultViewController {
    func configureCells(_ cell: SearchResultTableViewCell, forItemAt indexPath: IndexPath) {
        let song = songs[indexPath.row - 1]
        cell.vendorLabel.text = song.vendor
        cell.titleLabel.text = song.title
        cell.artistLabel.text = song.artist
        cell.albumLabel.text = song.album
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let shazamCell = resultTableView.dequeueReusableCell(
                withIdentifier: ShazamResultTableViewCell.identifier,
                for: indexPath) as! ShazamResultTableViewCell
            shazamCell.titleLabel.text = shazamSong.title
            shazamCell.artistLabel.text = shazamSong.artist
            shazamCell.albumLabel.text = shazamSong.album
            shazamCell.configure(with: shazamSong.imageURL!)
            
            return shazamCell
        }
        
        let resultCell = resultTableView.dequeueReusableCell(
            withIdentifier: SearchResultTableViewCell.identifier,
            for: indexPath) as! SearchResultTableViewCell
        configureCells(resultCell, forItemAt: indexPath)
        
        return resultCell
    }
    
    
}

extension SearchResultViewController {
    func getSongs() {
        guard let title = shazamSong.title,
              let artist = shazamSong.artist,
              let _ = shazamSong.album
        else { return }
        
        let searchQuery = title
                
        var melon = MelonAPI.init()
        melon.query = ["q": searchQuery]
        melon.loadMelonSong { (result) in
            guard let result = result else {
                return
            }
            DispatchQueue.main.async {
                for melonSong in result {
                    if melonSong.title == "" || melonSong.artist == "" || melonSong.album == "" {
                        continue
                    }
                    let song = Song(melonSong: melonSong)
                    self.songs.append(song)
                }
                self.resultTableView.reloadData()
            }
        }
        
        var genie = GenieAPI.init()
        genie.query = ["query": searchQuery]
        genie.loadGenieSong{ (result) in
            guard let result = result else {
                return
            }
            DispatchQueue.main.async {
                for genieSong in result {
                    if genieSong.title == "" || genieSong.artist == "" || genieSong.album == "" {
                        continue
                    }
                    let song = Song(genieSong: genieSong)
                    self.songs.append(song)
                }
                self.resultTableView.reloadData()
            }
        }
        
        var bugs = BugsAPI.init()
        bugs.query = ["q": searchQuery]
        bugs.loadBugsSong { (result) in
            guard let result = result else {
                return
            }
            DispatchQueue.main.async {
                for bugsSong in result {
                    if bugsSong.title == "" || bugsSong.artist == "" || bugsSong.album == "" {
                        continue
                    }
                    let song = Song(bugsSong: bugsSong)
                    self.songs.append(song)
                }
                self.resultTableView.reloadData()
            }
        }
        
        var apple = AppleAPI.init()
        apple.query = ["term": searchQuery, "country": "KR"]
        apple.loadAppleSong { (result) in
            guard let result = result else {
                return
            }
            DispatchQueue.main.async {
                for appleSong in result {
                    let song = Song(appleSong: appleSong)
                    self.songs.append(song)
                }
                self.resultTableView.reloadData()
            }
        }
        
        var flo = FloAPI.init()
        flo.query = ["keyword": searchQuery]
        flo.loadFloSong { (result) in
            guard let result = result else {
                return
            }
            DispatchQueue.main.async {
                for floSong in result {
                    let song = Song(floSong: floSong)
                    self.songs.append(song)
                }
                self.resultTableView.reloadData()
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
            guard let result = result else {
                return
            }
            DispatchQueue.main.async {
                for youTubeSong in result {
                    let song = Song(youTubeSong: youTubeSong)
                    self.songs.append(song)
                }
                self.resultTableView.reloadData()
            }
        }
        
    }
}
