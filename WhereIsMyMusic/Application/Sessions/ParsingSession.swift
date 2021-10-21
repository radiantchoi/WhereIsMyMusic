//
//  ParsingSession.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/10/21.
//

import Foundation

class ParsingSession: NSObject {
    var tracks = [VibeSongModel]()
    var xmlDictionary: [String: String]?
    var currentType: XMLKey?
    
    var completion: ((Result<VibeSongModel, ParsingError>) -> Void)?
}

extension ParsingSession: XMLParserDelegate {
    
    func start(baseUrl: URL, query: Query) {
        let url = baseUrl.withQueries(query)!
        let session = XMLParser(contentsOf: url)
        session?.delegate = self
        session?.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "track" {
            xmlDictionary = [:]
        } else if elementName == "trackTitle" {
            currentType = .trackTitle
        } else if elementName == "artistName" {
            currentType = .artistName
        } else if elementName == "albumTitle" {
            currentType = .albumTitle
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard xmlDictionary != nil,
              let currentType = self.currentType
        else { return }
        
        xmlDictionary?.updateValue(string, forKey: currentType.rawValue)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard let xmlDictionary = self.xmlDictionary
        else {
            self.completion?(.failure(.noData))
            return
        }
        if elementName == "track" {
            guard let trackTitle = xmlDictionary[XMLKey.trackTitle.rawValue],
                  let artistName = xmlDictionary[XMLKey.artistName.rawValue],
                  let albumtitle = xmlDictionary[XMLKey.albumTitle.rawValue]
            else {
                self.completion?(.failure(.noData))
                return
            }
            
            let track = VibeSongModel(trackTitle: trackTitle,
                              artistName: artistName,
                              albumTitle: albumtitle)
//            tracks.append(track)
            self.completion?(.success(track))
            self.xmlDictionary = nil
        }
        currentType = nil
    }
}

extension ParsingSession {
    
    enum ParsingError: Error {
        case noData
        
        var errorDescription: String? {
            switch self {
            case .noData:
                return "No data returned"
            }
        }
    }
    
}
