//
//  ShazamSearchViewController.swift
//  ShazamSearchViewController
//
//  Created by Gordon Choi on 2021/09/02.
//

import UIKit
import ShazamKit
import AVFoundation

class ShazamSearchViewController: UIViewController {
    
    @IBOutlet weak var shazamButton: UIButton!
    
    var mediaItem: SHMediaItem?
    var error: Error?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateUI),
                                               name: ShazamController.matchFoundNotification,
                                               object: nil )
    }
}

extension ShazamSearchViewController {
    
    @objc func updateUI() {
        self.mediaItem = ShazamController.shared.mediaItem ?? nil
        self.error = ShazamController.shared.error ?? nil
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
        ShazamController.shared.start()
    }

}
