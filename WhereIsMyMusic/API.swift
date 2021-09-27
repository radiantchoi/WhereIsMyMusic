//
//  API.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/09/25.
//

import Foundation
import Alamofire

struct API {
    let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 10.0
        return Session(configuration: configuration)
    }()
}

extension API {
   
}
