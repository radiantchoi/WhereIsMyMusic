//
//  NSObject+Extension.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/12/12.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: self)
    }
    
    static var className: String {
        return String(describing: self)
    }
    
    static var reuseIdentifier: String {
        return className + ".identifier"
    }
}
