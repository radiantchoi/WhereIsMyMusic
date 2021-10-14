//
//  SearchResultViewController.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/07.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
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
        self.titleLabel.text = self.shazamSong.title
        self.artistLabel.text = self.shazamSong.artist
        self.albumLabel.text = self.shazamSong.album
        self.albumImageView.load(self.shazamSong.imageURL)
        albumImageView.layer.cornerRadius = 4
        albumImageView.layer.masksToBounds = true
        getSongs()
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
    }
    
}
