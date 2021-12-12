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
    
    private var searching: Bool = true
    
}

extension ShazamSearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        micImageView.layer.cornerRadius = 50
        ShazamSession.shared.completion = {
            switch $0 {
            case .success(let shazamSong):
                let searchResultViewController = SearchResultViewController(shazamSong: shazamSong)
                let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
                backButton.tintColor = self.shazamButton.tintColor
                self.navigationItem.backBarButtonItem = backButton
                self.navigationController?.pushViewController(searchResultViewController, animated: true)
            case .failure(let error):
                self.alert(error)
                self.flicker()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        flicker()
    }
}

extension ShazamSearchViewController {
    func flicker() {
        searching.toggle()
        if searching {
            UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse]) {
                self.micImageView.alpha = 0
            }
            shazamButton.isEnabled = false
        } else {
            micImageView.layer.removeAllAnimations()
            micImageView.alpha = 1
            shazamButton.isEnabled = true
        }
    }
}

extension ShazamSearchViewController {
    @IBAction private func buttonPressed(_ sender: UIButton) {
        ShazamSession.shared.start()
        flicker()
    }
}
