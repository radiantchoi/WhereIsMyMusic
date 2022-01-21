//
//  ShazamResultTableViewCell.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/26.
//

import UIKit

class ShazamResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    
    static var nib: UINib {
        return UINib(nibName: "ShazamResultTableViewCell", bundle: nil)
    }
}

extension ShazamResultTableViewCell {    
    func configure(_ viewModel: ShazamResultTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        artistLabel.text = viewModel.artist
        albumLabel.text = viewModel.album
        
        albumImageView.load(viewModel.imageURL)
        albumImageView.layer.cornerRadius = 4
        albumImageView.layer.masksToBounds = true
    }
}
