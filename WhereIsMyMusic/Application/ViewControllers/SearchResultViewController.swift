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
        
        return table
    }()
    
    let shazamSong: ShazamSong
    
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

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultTableView.dequeueReusableCell(
            withIdentifier: ShazamResultTableViewCell.identifier,
            for: indexPath) as! ShazamResultTableViewCell
        cell.titleLabel.text = shazamSong.title
        cell.artistLabel.text = shazamSong.artist
        cell.albumLabel.text = shazamSong.album
        cell.configure(with: shazamSong.imageURL!)
        
        return cell
    }
    
    
}

extension SearchResultViewController {
    func getSongs() {
        guard let title = shazamSong.title,
              let artist = shazamSong.artist,
              let album = shazamSong.album
        else { return }
        
        let searchQuery = title
                
        var melon = MelonAPI.init()
        melon.query = ["q": searchQuery]
        melon.loadMelonSong { (result) in
            guard let result = result else {
                return
            }
            print(result)
        }
        
        var genie = GenieAPI.init()
        genie.query = ["query": searchQuery]
        genie.loadGenieSong{ (result) in
            guard let result = result else {
                return
            }
            print(result)
        }
        
        var bugs = BugsAPI.init()
        bugs.query = ["q": searchQuery]
        bugs.loadBugsSong { (result) in
            guard let result = result else {
                return
            }
            print(result)
        }
        
        var apple = AppleAPI.init()
        apple.query = ["term": searchQuery, "country": "KR"]
        apple.loadAppleSong { (result) in
            guard let result = result else {
                return
            }
            print(result)
        }
        
        var flo = FloAPI.init()
        flo.query = ["keyword": searchQuery]
        flo.loadFloSong { (result) in
            guard let result = result else {
                return
            }
            print(result)
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
            print(result)
        }
        
    }
}
