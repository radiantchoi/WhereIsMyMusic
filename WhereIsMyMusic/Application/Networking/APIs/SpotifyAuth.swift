//
//  SpotifyAuth.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/24.
//

import Foundation

struct SpotifyAuth {
    let clientID = "dbe85a8894f340e99c60621d1e2f572e"
    var clientSecret: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "Keys", ofType: "plist")
            else {
                fatalError("Couldn't find Keys.plist file")
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "SPOTIFY_CLIENT_SECRET") as? String
            else {
                fatalError("Couldn't find 'SPOTIFY_CLIENT_SECRET' in 'Keys.plist'.")
            }
            return value
        }
    }
    
    lazy var token: String = .init()
}

extension SpotifyAuth {
    mutating func getToken() {
        let url = URL(string: "https://accounts.spotify.com/api/token")!
        var postRequest = URLRequest(url: url)
        postRequest.httpMethod = "POST"
        let bodyParams = "grant_type=client_credentials"
        postRequest.httpBody = bodyParams.data(using: String.Encoding.ascii, allowLossyConversion: true)

        let id = clientID
        let secret = clientSecret
        let combo = "\(id):\(secret)".toBase64()
        postRequest.addValue("Basic \(combo)", forHTTPHeaderField: "Authorization")
        
        var tokenStorage = ""

        let task = URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
            guard let data = data else {
                return
            }
            let result = try? JSONDecoder().decode(AccessToken.self, from: data)
            tokenStorage = result?.accessToken ?? ""
        }
        task.resume()
        self.token = tokenStorage
    }
}
