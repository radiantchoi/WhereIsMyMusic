//
//  NetworkRequestData.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/09/25.
//

import Foundation

struct NetworkRequestData {
    var baseURL: URL
    var urlPath: String
    var data: [String: Any]?
}
