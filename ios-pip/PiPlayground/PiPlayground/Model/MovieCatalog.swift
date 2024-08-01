//
//  MovieCatalog.swift
//  PiPlayground
//
//  Created by Tiago Lopes on 01/02/24.
//

import Foundation

struct MovieCatalog {
    let movies: [Movie]
}

extension MovieCatalog {
    static var `default`: Self {
        MovieCatalog(movies: [
            Movie(
                title: "Charlla Dev Playlist",
                subtitle: "Playlist Key QFuoEZxk1AJ",
                url: URL(string: "https://dev-player-api.charlla.io/mp4/hxSwHB54eVe")!,
                charllaUrl: URL(string: "https://dev-player.charlla.io/shoplayer/list/QFuoEZxk1AJ?l=grid")!
            ),
            // Movie(
            //     title: "Charlla Dev Shoplayer",
            //     subtitle: "Shoplayer Key: hNRnNg2AG4x",
            //     url: URL(string: "https://dev-player-api.charlla.io/mp4/hxSwHB54eVe")!,
            //     charllaUrl: URL(string: "https://dev-player.charlla.io/shoplayer/hNRnNg2AG4x")!
            // ),
        ])
    }
}
