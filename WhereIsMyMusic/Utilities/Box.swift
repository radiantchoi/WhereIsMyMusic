//
//  Pack.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2022/01/08.
//

import Foundation

final class Box<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
}

extension Box {
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
