//
//  EndPoint.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/08.
//

import Foundation

struct EndPoint {
    let baseURL: URL
    let httpMethod: HTTPMethod
    let query: Query?
    let headers: [String: String]?
}

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}
