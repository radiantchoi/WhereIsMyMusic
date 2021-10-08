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
    
    var mediaItem: ShazamSong?
    var error: Error?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ShazamSession.shared.completion = { result in
            switch result {
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
    
    func updateUI() {
//        self.mediaItem = ShazamSession.shared.mediaItem ?? nil
//        self.error = ShazamSession.shared.error ?? nil
        DispatchQueue.main.async {
            if self.mediaItem == nil {
                print(self.error as Any)
                
            } else {
                
            }
        }
    }
}


extension ShazamSearchViewController {

    @IBAction private func buttonPressed(_ sender: UIButton) {
        ShazamSession.shared.start()
    }

}

