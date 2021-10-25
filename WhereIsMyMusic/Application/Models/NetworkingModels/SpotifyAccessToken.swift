//
//  SpotifyAuthModel.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/23.
//

import Foundation

struct AccessToken: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}
