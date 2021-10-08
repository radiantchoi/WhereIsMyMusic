//
//  ShazamController.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/02.
//

import Foundation
import ShazamKit

extension ShazamSession {
    typealias ResultType = Result<ShazamSong, ShazamError>
    typealias Completion = (ResultType) -> Void
    
    enum ShazamError: Error, LocalizedError {
        case recordDenied
        case unknown
        case matchFailed
        
        var errorDescription: String? {
            switch self {
            case .recordDenied:
                return "Record permission is denied. Please enable it in Settings."
            case .matchFailed:
                return "Failed to match with this music"
            case .unknown:
                return "Unknown error occured."
            }
        }
    }
}

final class ShazamSession: NSObject {

    static let shared = ShazamSession()
    
    var completion: Completion?
    
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


extension ShazamSession {
    func start() {
        switch audioSession.recordPermission {
        case .granted:
            self.record()
        case .denied:
            DispatchQueue.main.async {
                self.completion?(.failure(.recordDenied))
            }
        case .undetermined:
            audioSession.requestRecordPermission { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.record()
                    } else {
                        self.completion?(.failure(.recordDenied))
                    }
                }
            }
        @unknown default:
            DispatchQueue.main.async {
                self.completion?(.failure(.unknown))
            }
        }
    }
    
    func stop() {
        self.audioEngine.stop()
        self.inputNode.removeTap(onBus: bus)
    }
    
    private func record() {
        do {
            let format = self.inputNode.outputFormat(forBus: bus)
            self.inputNode.installTap(onBus: bus, bufferSize: 1024, format: format) { buffer, time in
                self.session.matchStreamingBuffer(buffer, at: time)
            }
            self.audioEngine.prepare()
            try self.audioEngine.start()
        } catch {
            self.completion?(.failure(.unknown))
        }
    }
}

extension ShazamSession: SHSessionDelegate {
    
    func session(_ session: SHSession, didFind match: SHMatch) {
        DispatchQueue.main.async {
            guard let mediaItem = match.mediaItems.first,
                  let shazamSong = ShazamSong(mediaItem: mediaItem)
            else {
                self.completion?(.failure(.matchFailed))
                return
            }
            
            self.completion?(.success(shazamSong))
            self.stop()
        }
    }
    
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        DispatchQueue.main.async {
            self.completion?(.failure(.matchFailed))
            self.stop()
        }
    }
}

extension SHMediaItemProperty {
    static let album = SHMediaItemProperty("sh_albumName")
}

extension SHMediaItem {
    var album: String? {
        return self[.album] as? String
    }
}
