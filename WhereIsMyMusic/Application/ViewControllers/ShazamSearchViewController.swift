//
//  ShazamSearchViewController.swift
//  ShazamSearchViewController
//
//  Created by Gordon Choi on 2021/09/02.
//

import UIKit
import ShazamKit

class ShazamSearchViewController: UIViewController {
    
    @IBOutlet weak var shazamButton: UIButton!
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
                print(error)
            }
        }
    }
}

extension ShazamSearchViewController {

    @IBAction private func buttonPressed(_ sender: UIButton) {
        ShazamSession.shared.start()
    }

}

