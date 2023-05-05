//
//  BugsSongEndpoint.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2023/03/01.
//

import Foundation

enum BugsSongEndpoint: Endpoint {
    case term(String)
    
    var baseURL: URL? {
        return BaseURL.bugs
    }
    
    var httpMethod: HTTPMethod {
        return .GET
    }
    
    var path: String {
        return ""
    }
    
    var parameters: HTTPRequestParameter? {
        switch self {
        case .term(let title):
            return HTTPRequestParameter.queries(["q":title])
        }
    }
}
