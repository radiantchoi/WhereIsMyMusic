//
//  ShazamSearchViewController.swift
//  ShazamSearchViewController
//
//  Created by Gordon Choi on 2021/09/02.
//

import UIKit
import ShazamKit

class ShazamSearchViewController: UIViewController {
    
    @IBOutlet private weak var shazamButton: UIButton!
}

extension ShazamSearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ShazamSession.shared.completion = {
            switch $0 {
            case .success(let shazamSong):
                let searchResultViewController = SearchResultViewController(shazamSong: shazamSong)
                self.navigationController?.pushViewController(searchResultViewController, animated: true)
            case .failure(let error):
//                print(error)
                let alert = UIAlertController(title: "Error!",
                                              message: error.errorDescription,
                                              preferredStyle: UIAlertController.Style.alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension ShazamSearchViewController {

    @IBAction private func buttonPressed(_ sender: UIButton) {
        ShazamSession.shared.start()
    }

}

