//
//  SearchMusicRepository.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2023/02/21.
//

import Foundation

import RxSwift

protocol SearchMusicRepository {
    func callFromAPI<T>(_ endpoint: Endpoint) -> Single<T> where T: Decodable
    func scrapFromWebsite(_ endpoint: Endpoint, css: ScrapingCSS) -> Single<[[String]]>
}

final class SearchMusicRepositoryImpl: SearchMusicRepository {
    func callFromAPI<T: Decodable>(_ endpoint: Endpoint) -> Single<T> {
        return NetworkingManager.shared
            .call(endpoint)
            .map {
                let decodedResult = try JSONDecoder().decode(T.self, from: $0)
                return decodedResult
            }
    }
    
    func scrapFromWebsite(_ endpoint: Endpoint, css: ScrapingCSS) -> Single<[[String]]> {
        return ScrapingManager.shared
            .scrap(endpoint, css: css)
    }
}
