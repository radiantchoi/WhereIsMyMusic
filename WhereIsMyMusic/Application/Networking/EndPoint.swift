//
//  EndPoint.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/08.
//

import Foundation

struct EndPoint {
    let baseURL: URL
    let query: Query
    let httpMethod: HTTPMethod
}

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}
