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
                       forCellReuseIdentifier: ShazamResultTableViewCell.reuseIdentifier)
        table.register(SearchResultTableViewCell.nib,
                       forCellReuseIdentifier: SearchResultTableViewCell.reuseIdentifier)
        
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
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.981432, green: 0.819418, blue: 0.149074, alpha: 1)
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
        cell.configure(song)
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let shazamCell = resultTableView.dequeueReusableCell(
                withIdentifier: ShazamResultTableViewCell.reuseIdentifier,
                for: indexPath) as! ShazamResultTableViewCell
            shazamCell.configure(shazamSong)
            
            return shazamCell
        }
        
        let resultCell = resultTableView.dequeueReusableCell(
            withIdentifier: SearchResultTableViewCell.reuseIdentifier,
            for: indexPath) as! SearchResultTableViewCell
        configureCells(resultCell, forItemAt: indexPath)
        
        return resultCell
    }
}

extension SearchResultViewController {
    static func push(in viewController: UIViewController, with shazamSong: ShazamSong) {
        let vc = SearchResultViewController(shazamSong: shazamSong)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}
