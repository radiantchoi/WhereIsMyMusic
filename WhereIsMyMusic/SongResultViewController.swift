//
//  SongResultViewController.swift
//  SongResultViewController
//
//  Created by Gordon Choi on 2021/09/02.
//

import UIKit
import ShazamKit

@available(iOS 15.0, *)
class SongResultViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    let session = SHSession()
    session.delegate = self
    
    let signatureGenerator = SHSignatureGenerator()
    try signatureGenerator.append(buffer, at: nil)
    
    let signature = signatureGenerator.signature()
    session.match(signature)
}

@available(iOS 15.0, *)
extension SongResultViewController: SHSessionDelegate {
    
    public func session(_ session: SHSession, didFind match: SHMatch) {
        guard let matchedMediaItem = match.mediaItems.first else { return }
        print(matchedMediaItem)
    }
}
