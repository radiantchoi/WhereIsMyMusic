//
//  ShazamController.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/02.
//

import Foundation
import ShazamKit

extension ShazamSession {
    
}

final class ShazamSession: NSObject {
    
    var completion: Completion?
    
    private lazy var audioSession: AVAudioSession = .sharedInstance()
    private lazy var session: SHSession = .init()
    private lazy var audioEngine: AVAudioEngine = .init()
    private lazy var inputNode = self.audioEngine.inputNode
    private lazy var bus: AVAudioNodeBus = 0
    
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
