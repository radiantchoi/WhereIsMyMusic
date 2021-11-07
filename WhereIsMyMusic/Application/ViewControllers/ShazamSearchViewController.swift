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
    @IBOutlet private weak var micImageView: UIImageView!
    
}

extension ShazamSearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        micImageView.layer.cornerRadius = 50
        ShazamSession.shared.completion = {
            switch $0 {
            case .success(let shazamSong):
                let searchResultViewController = SearchResultViewController(shazamSong: shazamSong)
                self.navigationController?.pushViewController(searchResultViewController, animated: true)
            case .failure(let error):
                let alert = UIAlertController(title: "Error!",
                                              message: error.errorDescription,
                                              preferredStyle: UIAlertController.Style.alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                self.micImageView.layer.removeAllAnimations()
                self.micImageView.alpha = 1
                self.shazamButton.isEnabled = true
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        micImageView.alpha = 1
        self.shazamButton.isEnabled = true
    }
}

extension ShazamSearchViewController {

    @IBAction private func buttonPressed(_ sender: UIButton) {
        ShazamSession.shared.start()
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse]) {
            self.micImageView.alpha = 0
        }
        self.shazamButton.isEnabled = false
    }

}

