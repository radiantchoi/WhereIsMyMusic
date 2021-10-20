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
}

extension ParsingSession: XMLParserDelegate {
    
    func parse(url: URL) {
        let parser = XMLParser(contentsOf: url)
        parser?.delegate = self
        parser?.parse()
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
        else { return }
        if elementName == "track" {
            guard let trackTitle = xmlDictionary[XMLKey.trackTitle.rawValue],
                  let artistName = xmlDictionary[XMLKey.artistName.rawValue],
                  let albumtitle = xmlDictionary[XMLKey.albumTitle.rawValue]
            else { return }
            
            let track = VibeSongModel(trackTitle: trackTitle,
                              artistName: artistName,
                              albumTitle: albumtitle)
            tracks.append(track)
            self.xmlDictionary = nil
        }
        currentType = nil
    }
}
