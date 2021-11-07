//
//  MelonTableViewCell.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/26.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    
    static let identifier = "SearchResultTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "SearchResultTableViewCell", bundle: nil)
    }
    
}

extension SearchResultTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}