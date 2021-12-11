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
        
        table.register(ShazamResultTableViewCell.nib,
                       forCellReuseIdentifier: ShazamResultTableViewCell.identifier)
        table.register(SearchResultTableViewCell.nib,
                       forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        
        return table
    }()
    
    private let shazamSong: ShazamSong
    private var songs: [Song] = .init()
   
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
        let session = ParsingSession()
        session.getSongs(shazamSong) { parsedSongs in
            DispatchQueue.main.async {
                self.songs.append(contentsOf: parsedSongs)
                self.resultTableView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        resultTableView.frame = view.bounds
    }
}

extension SearchResultViewController {
    private func configureCells(_ cell: SearchResultTableViewCell, forItemAt indexPath: IndexPath) {
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
