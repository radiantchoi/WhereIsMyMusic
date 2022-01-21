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
    case song(SearchResultTableViewCellViewModel)
}

class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var resultTableView: UITableView!
    
    private var dataSource = DataSource<Section, Row>()
    private var viewModel: SearchResultViewViewModel
    
    init(viewModel: SearchResultViewViewModel) {
        self.viewModel = viewModel
        
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
        
        setupSongs()
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
        case .song(let viewModel):
            let cell = resultTableView.dequeueReusableCell(
                withIdentifier: SearchResultTableViewCell.reuseIdentifier,
                for: indexPath) as! SearchResultTableViewCell
            cell.configure(viewModel)
            return cell
        }
    }
}

extension SearchResultViewController {
    private func setupSongs() {
        self.dataSource.removeAllSections()
        self.dataSource.appendSection(.shazam, with: [.shazam(viewModel.shazamSong)])
        self.dataSource.appendSection(.song, with: [])
        
        viewModel.songs.bind { [weak self] songs in
            self?.dataSource.removeAllItems(in: .song)
            songs.forEach {
                self?.dataSource.append([.song($0)], in: .song)
            }
            self?.resultTableView.reloadData()
        }
        viewModel.setSongData()
    }
}

extension SearchResultViewController {
    static func push(in viewController: UIViewController, with shazamSong: ShazamSong) {
        let viewModel = SearchResultViewViewModel(shazamSong: shazamSong)
        let vc = SearchResultViewController(viewModel: viewModel)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}
