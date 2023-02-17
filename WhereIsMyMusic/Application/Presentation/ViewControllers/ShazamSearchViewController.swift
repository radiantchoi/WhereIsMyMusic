//
//  ShazamSearchViewController.swift
//  ShazamSearchViewController
//
//  Created by Gordon Choi on 2021/09/02.
//

import ShazamKit
import UIKit

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
        viewModel.shazamSong.asObserver()
            .subscribe(onNext: { shazamSong in
                SearchResultViewController.push(in: self, with: shazamSong)
            })
            .disposed(by: disposeBag)
        
        viewModel.error.asObserver()
            .subscribe(onNext: { [weak self] error in
                self?.alert(error)
            })
            .disposed(by: disposeBag)
        
        viewModel.searching.asObserver()
            .subscribe(onNext: { [weak self] _ in
                self?.flicker()
            })
            .disposed(by: disposeBag)
    }
    
    private func flicker() {
        viewModel.searching.asObserver()
            .subscribe(onNext: { [weak self] value in
                if value {
                    self?.startAnimation()
                } else {
                    self?.terminateAnimation()
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
