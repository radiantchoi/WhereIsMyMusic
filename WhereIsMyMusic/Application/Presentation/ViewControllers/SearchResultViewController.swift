//
//  SearchResultViewController.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/07.
//

import UIKit

private enum Section {
    case shazam
    case song
}

private enum Row: Equatable {
    case shazam(ShazamSong)
    case song(Song)
}

class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var resultTableView: UITableView!
    
    private let shazamSong: ShazamSong
    private var songs: [Song] = .init()
    private var dataSource = DataSource<Section, Row>()
    
    init(shazamSong: ShazamSong) {
        self.shazamSong = shazamSong
        dataSource.appendSection(.shazam, with: [.shazam(shazamSong)])
        
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
        resultTableView.register(ShazamResultTableViewCell.nib,
                                 forCellReuseIdentifier: ShazamResultTableViewCell.reuseIdentifier)
        resultTableView.register(SearchResultTableViewCell.nib,
                                 forCellReuseIdentifier: SearchResultTableViewCell.reuseIdentifier)
        
        setSongData()
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = dataSource.item(for: indexPath)
        
        switch row {
        case .shazam(let shazamSong):
            let shazamCell = resultTableView.dequeueReusableCell(
                withIdentifier: ShazamResultTableViewCell.reuseIdentifier,
                for: indexPath) as! ShazamResultTableViewCell
            shazamCell.configure(shazamSong)
            return shazamCell
        case .song(let song):
            let cell = resultTableView.dequeueReusableCell(
                withIdentifier: SearchResultTableViewCell.reuseIdentifier,
                for: indexPath) as! SearchResultTableViewCell
            cell.configure(song)
            return cell
        }
    }
}

extension SearchResultViewController {
    func setSongData() {
        let session = ParsingSession()
        session.getSongs(shazamSong) { parsedSongs in
            self.songs.append(contentsOf: parsedSongs)
            self.dataSource.appendSection(.song, with: [])
            parsedSongs.forEach {
                self.dataSource.append([.song($0)], in: .song)
            }
            self.resultTableView.reloadData()
        }
    }
}

extension SearchResultViewController {
    static func push(in viewController: UIViewController, with shazamSong: ShazamSong) {
        let vc = SearchResultViewController(shazamSong: shazamSong)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}
