//
//  MelonTableViewCell.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/26.
//

import UIKit
import MarqueeLabel

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var titleLabel: MarqueeLabel!
    @IBOutlet weak var artistLabel: MarqueeLabel!
    @IBOutlet weak var albumLabel: MarqueeLabel!
    
    static var nib: UINib {
        return UINib(nibName: "SearchResultTableViewCell", bundle: nil)
    }
}

extension SearchResultTableViewCell {
    func configure(_ viewModel: SearchResultTableViewCellViewModel) {
        labelTuning(titleLabel)
        labelTuning(artistLabel)
        labelTuning(albumLabel)
        
        vendorLabel.text = viewModel.vendor
        titleLabel.text = viewModel.title
        artistLabel.text = viewModel.artist
        albumLabel.text = viewModel.album
    }
    
    func labelTuning(_ label: MarqueeLabel) {
        label.speed = .duration(20)
        label.trailingBuffer = 20
    }
}
