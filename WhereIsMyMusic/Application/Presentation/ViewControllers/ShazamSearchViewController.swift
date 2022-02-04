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
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var micImageView: UIImageView!

    private var viewModel = ShazamSearchViewViewModel()
}

extension ShazamSearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        micImageView.layer.cornerRadius = 50
        
        viewModel.shazamSong.bind { [weak self] shazamSong in
            guard let vc = self,
                  let shazamSong = shazamSong
            else { return }
            SearchResultViewController.push(in: vc, with: shazamSong)
        }
        
        viewModel.error.bind { [weak self] error in
            guard let error = error
            else { return }
            self?.alert(error)
        }
        
        viewModel.searching.bind{ [weak self] toggle in
            self?.flicker()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        flicker()
    }
}

extension ShazamSearchViewController {
    private func flicker() {
        if viewModel.searching.value {
            UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse]) {
                self.micImageView.alpha = 0
            }
            shazamButton.isEnabled = false
            cancelButton.isEnabled = true
        } else {
            micImageView.layer.removeAllAnimations()
            micImageView.alpha = 1
            shazamButton.isEnabled = true
            cancelButton.isEnabled = false
        }
    }
}

extension ShazamSearchViewController {
    @IBAction private func searchPressed(_ sender: UIButton) {
        viewModel.shazamSession.start()
        viewModel.searching.value = true
        flicker()
    }
    
    @IBAction private func cancelPressed(_ sender: UIButton) {
        viewModel.shazamSession.stop()
        viewModel.searching.value = false
        flicker()
    }
}
