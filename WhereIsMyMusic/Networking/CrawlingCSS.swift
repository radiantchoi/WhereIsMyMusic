//
//  CrawlingCSS.swift
//  WhereIsMyMusic
//
//  Created by Gordon Choi on 2021/12/08.
//

import Foundation

struct CrawlingCSS {
    let cssQuery: String
    let titleCss: [String]
    let artistCss: [String]
    let albumCss: [String]
}

extension CrawlingCSS {
    static var melon: CrawlingCSS {
        CrawlingCSS(
            cssQuery: "#frm_defaultList > div > table > tbody",
            titleCss: ["tr:nth-child(1) > td:nth-child(3) > div > div > a.fc_gray",
                       "tr:nth-child(2) > td:nth-child(3) > div > div > a.fc_gray",
                       "tr:nth-child(3) > td:nth-child(3) > div > div > a.fc_gray"],
            artistCss: ["tr:nth-child(1) > td:nth-child(4) > div > div > a",
                        "tr:nth-child(2) > td:nth-child(4) > div > div > a",
                        "tr:nth-child(3) > td:nth-child(4) > div > div > a"],
            albumCss: ["tr:nth-child(1) > td:nth-child(5) > div > div > a",
                       "tr:nth-child(2) > td:nth-child(5) > div > div > a",
                       "tr:nth-child(3) > td:nth-child(5) > div > div > a"]
        )
    }
    
    static var genie: CrawlingCSS {
        CrawlingCSS(cssQuery: "#body-content > div.search_song > div.music-list-wrap > div.music-list-wrap > table > tbody",
                    titleCss: ["tr:nth-child(1) > td.info > a.title.ellipsis",
                               "tr:nth-child(2) > td.info > a.title.ellipsis",
                               "tr:nth-child(3) > td.info > a.title.ellipsis"],
                    artistCss: ["tr:nth-child(1) > td.info > a.artist.ellipsis",
                                "tr:nth-child(2) > td.info > a.artist.ellipsis",
                                "tr:nth-child(3) > td.info > a.artist.ellipsis"],
                    albumCss: ["tr:nth-child(1) > td.info > a.albumtitle.ellipsis",
                               "tr:nth-child(2) > td.info > a.albumtitle.ellipsis",
                               "tr:nth-child(3) > td.info > a.albumtitle.ellipsis"]
        )
    }
    
    static var bugs: CrawlingCSS {
        CrawlingCSS(cssQuery: "#DEFAULT0 > table > tbody",
                    titleCss: ["tr:nth-child(1) > th > p > a",
                               "tr:nth-child(2) > th > p > a",
                               "tr:nth-child(3) > th > p > a"],
                    artistCss: ["tr:nth-child(1) > td:nth-child(7) > p > a",
                                "tr:nth-child(2) > td:nth-child(7) > p > a",
                                "tr:nth-child(3) > td:nth-child(7) > p > a"],
                    albumCss: ["tr:nth-child(1) > td:nth-child(8) > a",
                               "tr:nth-child(2) > td:nth-child(8) > a",
                               "tr:nth-child(3) > td:nth-child(8) > a"]
        )
    }
}
