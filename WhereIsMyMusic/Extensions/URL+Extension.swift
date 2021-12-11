//
//  URL+Extension.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/08.
//

import Foundation

typealias Query = [String: String]

extension URL {
    func withQueries(_ query: Query) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        
        components?.queryItems = query.map {
            URLQueryItem(name: $0.0, value: $0.1)
        }
        
        return components?.url
    }
}
