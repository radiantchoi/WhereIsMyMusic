//
//  ShazamController.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/02.
//

import Foundation
import ShazamKit

import RxSwift

final class ShazamSession: NSObject {
    private var shazamResult = PublishSubject<ShazamSongDTO>()
    private var shazamError = PublishSubject<ShazamError>()
    private var isSearching = BehaviorSubject(value: false)
    
    var shazamResultObservable: Observable<ShazamSongDTO> {
        return shazamResult.asObservable()
    }
    var shazamErrorObservable: Observable<ShazamError> {
        return shazamError.asObservable()
    }
    var isSearchingObservable: Observable<Bool> {
        return isSearching.asObservable()
    }
    
    private lazy var audioSession: AVAudioSession = .sharedInstance()
    private lazy var session: SHSession = .init()
    private lazy var audioEngine: AVAudioEngine = .init()
    private lazy var inputNode = audioEngine.inputNode
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
            record()
        case .denied:
            shazamError.onNext(ShazamError.recordDenied)
        case .undetermined:
            audioSession.requestRecordPermission { [weak self] granted in
                if granted {
                    self?.record()
                } else {
                    self?.shazamError.onNext(ShazamError.recordDenied)
                }
            }
        @unknown default:
            shazamError.onNext(ShazamError.unknown)
        }
    }
    
    func stop() {
        audioEngine.stop()
        inputNode.removeTap(onBus: bus)
        isSearching.onNext(false)
    }
    
    private func record() {
        do {
            let format = self.inputNode.outputFormat(forBus: bus)
            inputNode.installTap(onBus: bus, bufferSize: 1024, format: format) { [weak self] buffer, time in
                self?.session.matchStreamingBuffer(buffer, at: time)
            }
            audioEngine.prepare()
            try audioEngine.start()
            isSearching.onNext(true)
        } catch {
            shazamError.onNext(ShazamError.unknown)
        }
    }
}

extension ShazamSession: SHSessionDelegate {
    func session(_ session: SHSession, didFind match: SHMatch) {
        guard let mediaItem = match.mediaItems.first,
              let shazamSong = ShazamSongDTO(mediaItem: mediaItem) else {
            shazamError.onNext(ShazamError.matchFailed)
            stop()
            return
        }
        
        shazamResult.onNext((shazamSong))
        stop()
    }
    
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        shazamError.onNext(ShazamError.matchFailed)
        stop()
    }
}
