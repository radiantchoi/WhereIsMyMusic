//
//  ShazamSearchViewController.swift
//  ShazamSearchViewController
//
//  Created by Gordon Choi on 2021/09/02.
//

import UIKit
import ShazamKit
import RxSwift

class ShazamSearchViewController: UIViewController {
    @IBOutlet private weak var shazamButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var micImageView: UIImageView!
    @IBOutlet private weak var progressBar: UIProgressView!
    
    private var viewModel = ShazamSearchViewViewModel()
    
    private let disposeBag = DisposeBag()
}

extension ShazamSearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        micImageView.layer.cornerRadius = 50
        
        viewModel.shazamSong.asObserver()
            .subscribe(onNext: { shazamSong in
                SearchResultViewController.push(in: self, with: shazamSong)
            }).disposed(by: disposeBag)
        
        viewModel.error.asObserver()
            .subscribe(onNext: { error in
                self.alert(error)
            }).disposed(by: disposeBag)
        
        viewModel.searching.asObserver()
            .subscribe(onNext: { toggle in
                self.flicker()
            }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        flicker()
    }
}

extension ShazamSearchViewController {
    private func flicker() {
        viewModel.searching.asObserver()
            .subscribe(onNext: { value in
                if value {
                    UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse]) {
                        self.micImageView.alpha = 0
                    }
                    UIView.animate(withDuration: 12.0) {
                        self.progressBar.setProgress(1.0, animated: true)
                    }
                    self.shazamButton.isEnabled = false
                    self.cancelButton.isEnabled = true
                    
                } else {
                    self.micImageView.layer.removeAllAnimations()
                    self.micImageView.alpha = 1
                    self.progressBar.layer.removeAllAnimations()
                    self.progressBar.setProgress(0, animated: false)
                    self.shazamButton.isEnabled = true
                    self.cancelButton.isEnabled = false
                }
            }).disposed(by: disposeBag)
    }
}

extension ShazamSearchViewController {
    @IBAction private func searchPressed(_ sender: UIButton) {
        viewModel.shazamSession.start()
        viewModel.searching.onNext(true)
        flicker()
    }
    
    @IBAction private func cancelPressed(_ sender: UIButton) {
        viewModel.shazamSession.stop()
        viewModel.searching.onNext(false)
        flicker()
    }
}
