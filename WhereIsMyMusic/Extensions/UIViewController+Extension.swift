//
//  UIViewController+Extension.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/12/12.
//

import Foundation
import UIKit

extension UIViewController {
    func alert(_ error: ShazamError) {
        let alert = UIAlertController(title: "Error!",
                                      message: error.errorDescription,
                                      preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
