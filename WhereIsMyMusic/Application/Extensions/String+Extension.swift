//
//  String+Extention.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/23.
//

import Foundation

extension String {
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
