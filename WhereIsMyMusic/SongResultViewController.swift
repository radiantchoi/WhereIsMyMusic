//
//  SongResultViewController.swift
//  SongResultViewController
//
//  Created by Gordon Choi on 2021/09/02.
//

import UIKit
import ShazamKit
import AVKit
import AVFoundation


@available(iOS 15.0, *)
class SongResultViewController: UIViewController, SHSessionDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var shazamButton: UIButton!
    
    let shazamSession = SHSession()
    let audioEngine = AVAudioEngine()
    let audioPlayer = AVAudioPlayerNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shazamSession.delegate = self
    }
    
    //MARK: Shazam song recognizing logic (reference by iOSAcademy)
    private func recognizeSong() {
        guard let url = Bundle.main.url(forResource: "song", withExtension: "mp3") else {
            print("Failed to get song url")
            return
        }
        
        guard let signature = SignatureGenerator.generateSignature(from: url) else { return }
        
        shazamSession.match(signature)
    }
    
    func session(_ session: SHSession, didFind match: SHMatch) {
        let items = match.mediaItems
        items.forEach { item in
            print(item.title ?? "title")
            print(item.artist ?? "artist")
            print(item.artworkURL?.absoluteURL ?? "Artwork url")
            DispatchQueue.main.async {
                self.titleLabel.text = item.title ?? "title"
                self.artistLabel.text = item.artist ?? "artist"
            }
        }
    }
    
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        if let error = error {
            print(error)
        }
    }
    
    @IBAction private func buttonPressed(_ sender: UIButton) {
        titleLabel.text = "Searching..."
        artistLabel.text = "Searching..."
        recognizeSong()
    }
}
