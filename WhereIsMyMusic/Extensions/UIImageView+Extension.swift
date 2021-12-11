//
//  UIImageView+Extension.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/08.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func load(_ url: URL?) {
        kf.setImage(with: url, placeholder: nil, options: nil, completionHandler: nil)
    }
}
