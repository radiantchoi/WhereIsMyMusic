//
//  SongResultViewController.swift
//  SongResultViewController
//
//  Created by Gordon Choi on 2021/09/02.
//

import UIKit
import ShazamKit
import AVKit


@available(iOS 15.0, *)
class SongResultViewController: UIViewController, SHSessionDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var shazamButton: UIButton!
    
    let shazamSession = SHSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: Shazam song recognizing logic (reference by iOSAcademy)
    private func recognizeSong() {
        
        shazamSession.delegate = self
        
        do {
            // Get track
            guard let url = Bundle.main.url(forResource: "song", withExtension: "mp3") else {
                print("Failed to get song url")
                return
            }
            
            // Create Audio File
            let file = try AVAudioFile(forReading: url)
            
            // Audio -> Buffer
            guard let buffer = AVAudioPCMBuffer(
                pcmFormat: file.processingFormat,
                frameCapacity: AVAudioFrameCount(file.length / 30)
            ) else {
                print("Failed to create buffer")
                return
            }
            try file.read(into: buffer)
            
            // SignatureGenerator
            let generator = SHSignatureGenerator()
            try generator.append(buffer, at: nil)
            
            // Create Signature
            let signature = generator.signature()
            
            // Try to match
            shazamSession.match(signature)
            
        }
        catch {
            print(error)
        }
    }

    
    func session(_ session: SHSession, didFind match: SHMatch) {
        let items = match.mediaItems
        items.forEach { item in
            print(item.title ?? "title")
            print(item.artist ?? "artist")
            print(item.artworkURL?.absoluteURL ?? "Artwork url")
            titleLabel.text = item.title ?? "title"
            artistLabel.text = item.artist ?? "artist"
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
