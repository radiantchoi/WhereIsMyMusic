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
    
    private let shazamSession = ShazamSession()
    private var searching: Bool = false

}

extension ShazamSearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        micImageView.layer.cornerRadius = 50
        shazamSession.completion = {
            switch $0 {
            case .success(let shazamSong):
                self.searching.toggle()
                self.flicker()
                SearchResultViewController.push(in: self, with: shazamSong)
            case .failure(let error):
                self.searching.toggle()
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
        shazamSession.start()
        searching.toggle()
        flicker()
    }
}
