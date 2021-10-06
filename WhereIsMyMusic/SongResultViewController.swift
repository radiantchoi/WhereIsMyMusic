//
//  SongResultViewController.swift
//  SongResultViewController
//
//  Created by Gordon Choi on 2021/09/02.
//

import UIKit
import ShazamKit
import AVFoundation

class SongResultViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var shazamButton: UIButton!
    @IBOutlet weak var checkLabel: UILabel!
    
    var mediaItem: SHMediaItem?
    var error: Error?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLabel.isHidden = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateUI),
                                               name: ShazamController.matchFoundNotification,
                                               object: nil )
    }
}

extension SongResultViewController {
    
    @objc func updateUI() {
        self.mediaItem = ShazamController.shared.mediaItem ?? nil
        self.error = ShazamController.shared.error ?? nil
        DispatchQueue.main.async {
            if self.mediaItem == nil {
                print(self.error as Any)
                self.titleLabel.text = "Not found"
                self.artistLabel.text = "Not found"
                self.albumLabel.text = "Not found"
            } else {
                self.titleLabel.text = self.mediaItem?.title
                self.artistLabel.text = self.mediaItem?.artist
                self.albumLabel.text = self.mediaItem?.album
            }
        }
    }
    
}


extension SongResultViewController {

    @IBAction private func buttonPressed(_ sender: UIButton) {
        titleLabel.text = "Searching..."
        artistLabel.text = "Searching..."
        albumLabel.text = "Searching..."
        ShazamController.shared.start()
    }

}
