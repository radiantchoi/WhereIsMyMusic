//
//  Array+Extension.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/12/12.
//

import Foundation

extension Array {
    func slice(first n: Int) -> Array<Element> {
        if self.count >= n {
            return Array(self[0...(n-1)])
        } else {
            return self
        }
    }
}
