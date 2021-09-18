//
//  SongResultViewController.swift
//  SongResultViewController
//
//  Created by Gordon Choi on 2021/09/02.
//

import UIKit
import ShazamKit
import AVFoundation

@available(iOS 15.0, *)
class SongResultViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var shazamButton: UIButton!
    
    var matching: Bool = false
    var mediaItem: SHMatchedMediaItem?
    var error: Error? {
        didSet {
            hasError = error != nil
        }
    }
    var hasError: Bool = false
    
    lazy var shazamSession: SHSession = .init()
    lazy var audioEngine: AVAudioEngine = .init()
//    let audioPlayer = AVAudioPlayerNode()
    
    lazy var audioSession: AVAudioSession = .sharedInstance()
    lazy var inputNode = audioEngine.inputNode
    lazy var bus: AVAudioNodeBus = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shazamSession.delegate = self
    }
    
}

// MARK: recorder Setup
@available(iOS 15.0, *)
extension SongResultViewController {
    
    private func record() {
        do {
            self.matching = true
            let format = self.inputNode.outputFormat(forBus: bus)
            self.inputNode.installTap(onBus: bus, bufferSize: 1024, format: format) { buffer, time in
                self.shazamSession.matchStreamingBuffer(buffer, at: time)
            }
            self.audioEngine.prepare()
            try self.audioEngine.start()
        } catch {
            self.error = error
        }
    }
    
    func start() {
        switch audioSession.recordPermission {
        case .granted:
            self.record()
        case .denied:
            print("Record denied")
        case .undetermined:
            audioSession.requestRecordPermission { granted in
                if granted {
                    self.record()
                } else {
                    print("Record denied")
                }
            }
        @unknown default:
            print("Unknown error")
        }
    }
    
    func stop() {
        self.audioEngine.stop()
        self.inputNode.removeTap(onBus: bus)
        self.matching = false
    }
    
}


// MARK: Shazam song recognizing logic
@available(iOS 15.0, *)
extension SongResultViewController: SHSessionDelegate {
    
//    private func recognizeSong() {
//        guard let url = Bundle.main.url(forResource: "song", withExtension: "mp3") else {
//            print("Failed to get song url")
//            return
//        }
//        guard let signature = SignatureGenerator.generateSignature(from: url) else { return }
//
//        shazamSession.match(signature)
//    }
    
    
    func session(_ session: SHSession, didFind match: SHMatch) {
//        let items = match.mediaItems
//        items.forEach { item in
//            print(item.title ?? "title")
//            print(item.artist ?? "artist")
//            print(item.artworkURL?.absoluteURL ?? "Artwork url")
//            DispatchQueue.main.async {
//                self.titleLabel.text = item.title ?? "title"
//                self.artistLabel.text = item.artist ?? "artist"
//            }
//        }
        
        DispatchQueue.main.async {
            if let mediaItem = match.mediaItems.first {
                self.mediaItem = mediaItem
                self.stop()
                self.titleLabel.text = mediaItem.title ?? "title"
                self.artistLabel.text = mediaItem.artist ?? "artist"
            }
        }
    }
    
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        if let error = error {
            print(error)
            self.stop()
        }
    }
    
    @IBAction private func buttonPressed(_ sender: UIButton) {
        titleLabel.text = "Searching..."
        artistLabel.text = "Searching..."
//        recognizeSong()
        start()
    }
    
}
