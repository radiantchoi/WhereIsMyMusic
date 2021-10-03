//
//  ShazamController.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/02.
//

import Foundation
import ShazamKit

final class ShazamController: NSObject {
    
    static let shared = ShazamController()
    static let matchFoundNotification = Notification.Name("ShazamController.matchFound")
    
    enum ShazamError: Error, LocalizedError {
        case recordDenied
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .recordDenied:
                return "Record permission is denied. Please enable it in Settings."
            case .unknown:
                return "Unknown error occured."
            }
        }
    }
    
    var matching: Bool = false
    var mediaItem: SHMatchedMediaItem?
    var error: Error? {
        didSet {
            hasError = error != nil
        }
    }
    var hasError: Bool = false
    
    lazy var audioSession: AVAudioSession = .sharedInstance()
    lazy var session: SHSession = .init()
    lazy var audioEngine: AVAudioEngine = .init()
    lazy var inputNode = self.audioEngine.inputNode
    lazy var bus: AVAudioNodeBus = 0
    
    override init() {
        super.init()
        session.delegate = self
    }
}


extension ShazamController {
    func start() {
        switch audioSession.recordPermission {
        case .granted:
            self.record()
        case .denied:
            DispatchQueue.main.async {
                self.error = ShazamError.recordDenied
            }
        case .undetermined:
            audioSession.requestRecordPermission { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.record()
                    } else {
                        self.error = ShazamError.recordDenied
                    }
                }
            }
        @unknown default:
            DispatchQueue.main.async {
                self.error = ShazamError.unknown
            }
        }
    }
    
    func stop() {
        self.audioEngine.stop()
        self.inputNode.removeTap(onBus: bus)
        self.matching = false
    }
    
    private func record() {
        do {
            self.matching = true
            let format = self.inputNode.outputFormat(forBus: bus)
            self.inputNode.installTap(onBus: bus, bufferSize: 1024, format: format) { buffer, time in
                self.session.matchStreamingBuffer(buffer, at: time)
            }
            self.audioEngine.prepare()
            try self.audioEngine.start()
        } catch {
            self.error = error
        }
    }
}


extension ShazamController: SHSessionDelegate {
    
    func session(_ session: SHSession, didFind match: SHMatch) {
        DispatchQueue.main.async {
            if let mediaItem = match.mediaItems.first {
                self.mediaItem = mediaItem
                self.stop()
            }
            NotificationCenter.default.post(name: ShazamController.matchFoundNotification, object: nil)
        }
    }
    
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        DispatchQueue.main.async {
            self.error = error
            self.stop()
        }
    }
}
