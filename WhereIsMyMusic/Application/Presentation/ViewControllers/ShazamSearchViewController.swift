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
        
//        viewModel.shazamSong.bind { [weak self] shazamSong in
//            guard let vc = self,
//                  let shazamSong = shazamSong
//            else { return }
//            SearchResultViewController.push(in: vc, with: shazamSong)
//        }
        
        viewModel.shazamSong.asObserver()
            .subscribe(onNext: { shazamSong in
                SearchResultViewController.push(in: self, with: shazamSong)
            }).disposed(by: disposeBag)
        
//        viewModel.error.bind { [weak self] error in
//            guard let error = error
//            else { return }
//            self?.alert(error)
//        }
        
        viewModel.error.asObserver()
            .subscribe(onNext: { error in
                self.alert(error)
            }).disposed(by: disposeBag)
        
//        viewModel.searching.bind{ [weak self] toggle in
//            self?.flicker()
//        }
        
        viewModel.searching.asObserver()
            .subscribe(onNext: { sig in
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
        let value = (try? viewModel.searching.value()) ?? false
        if value {
            UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse]) {
                self.micImageView.alpha = 0
            }
            UIView.animate(withDuration: 12.0) {
                self.progressBar.setProgress(1.0, animated: true)
            }
            shazamButton.isEnabled = false
            cancelButton.isEnabled = true
            
        } else {
            micImageView.layer.removeAllAnimations()
            micImageView.alpha = 1
            progressBar.layer.removeAllAnimations()
            progressBar.setProgress(0, animated: false)
            shazamButton.isEnabled = true
            cancelButton.isEnabled = false
        }
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
        viewModel.searching.onNext(true)
        flicker()
    }
}
