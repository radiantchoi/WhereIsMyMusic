//
//  MelonTableViewCell.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/26.
//

import UIKit

class MelonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
}

extension MelonTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
