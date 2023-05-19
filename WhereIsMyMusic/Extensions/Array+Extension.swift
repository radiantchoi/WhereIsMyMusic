//
//  Array+Extension.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/12/12.
//

import Foundation

extension Array {
    func slice(first n: Int) -> Self {
        return count >= n
        ? Array(self[0..<n])
        : self
    }
}
