//
//  ShazamSearchViewController.swift
//  ShazamSearchViewController
//
//  Created by Gordon Choi on 2021/09/02.
//

import ShazamKit
import UIKit

import RxCocoa
import RxSwift

final class ShazamSearchViewController: UIViewController {
    @IBOutlet private weak var shazamButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var micImageView: UIImageView!
    @IBOutlet private weak var progressBar: UIProgressView!
    
    private let viewModel = ShazamSearchViewViewModel()
    
    private let disposeBag = DisposeBag()
}

extension ShazamSearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindViewModel()
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        flicker()
    }
}

extension ShazamSearchViewController {
    private func setupView() {
        micImageView.layer.cornerRadius = 50
    }
    
    private func bindViewModel() {
        viewModel.shazamSong
            .subscribe(onNext: { shazamSong in
                DispatchQueue.main.async {
                    SearchResultViewController.push(in: self, with: shazamSong)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.shazamError
            .subscribe(onNext: { [weak self] error in
                DispatchQueue.main.async {
                    self?.alert(error)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.searching
            .subscribe(onNext: { [weak self] _ in
                self?.flicker()
            })
            .disposed(by: disposeBag)
    }
    
    private func flicker() {
        viewModel.searching
            .subscribe(onNext: { [weak self] value in
                DispatchQueue.main.async {
                    if value {
                        self?.startAnimation()
                    } else {
                        self?.terminateAnimation()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func startAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse]) { [weak self] in
            self?.micImageView.alpha = 0
        }
        
        UIView.animate(withDuration: 12.0) { [weak self] in
            self?.progressBar.setProgress(1.0, animated: true)
        }
        
        disableSearching()
    }
    
    private func terminateAnimation() {
        micImageView.layer.removeAllAnimations()
        micImageView.alpha = 1
        
        progressBar.layer.removeAllAnimations()
        progressBar.setProgress(0, animated: false)
        
        enableSearching()
    }
    
    private func enableSearching() {
        shazamButton.isEnabled = true
        cancelButton.isEnabled = false
    }
    
    private func disableSearching() {
        shazamButton.isEnabled = false
        cancelButton.isEnabled = true
    }
}

extension ShazamSearchViewController {
    private func bindAction() {
        shazamButton.rx.tap
            .withUnretained(self)
            .bind { _ in
                self.startSearching()
            }
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .withUnretained(self)
            .bind { _ in
                self.stopSearching()
            }
            .disposed(by: disposeBag)
    }
    
    private func startSearching() {
        viewModel.startSearching()
        flicker()
    }
    
    private func stopSearching() {
        viewModel.stopSearching()
        flicker()
    }
}
