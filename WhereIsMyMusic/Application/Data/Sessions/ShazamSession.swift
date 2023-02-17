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
    var completion = PublishSubject<Result<ShazamSong, ShazamError>>()
    
    private var isSearching = BehaviorSubject(value: false)
    private var shazamResult = PublishSubject<ShazamSong>()
    private var shazamError = PublishSubject<ShazamError>()
    
    var searchingStatusObservable: Observable<Bool> {
        return isSearching.asObservable()
    }
    var shazamResultObservable: Observable<ShazamSong> {
        return shazamResult.asObservable()
    }
    var shazamErrorObservable: Observable<ShazamError> {
        return shazamError.asObservable()
    }
    
    private lazy var audioSession: AVAudioSession = .sharedInstance()
    private lazy var session: SHSession = .init()
    private lazy var audioEngine: AVAudioEngine = .init()
    private lazy var inputNode = audioEngine.inputNode
    private lazy var bus: AVAudioNodeBus = 0
    
//    private var audioEngineStatus: Bool {
//        return audioEngine.isRunning
//    }
//
//    var isSearchingObservable: Observable<Bool> {
//        return Observable.create { observer in
//            observer.onNext(self.audioEngineStatus)
//
//            return Disposables.create()
//        }
//    }
    
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
              let shazamSong = ShazamSong(mediaItem: mediaItem) else {
            shazamError.onNext(ShazamError.matchFailed)
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
