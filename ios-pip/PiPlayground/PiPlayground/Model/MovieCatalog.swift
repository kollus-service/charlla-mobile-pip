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
                // title: "Big Buck Bunny",
                // subtitle: "By Blender Foundation",
                title: "Charlla Dev Playlist",
                subtitle: "Playlist Key QFuoEZxk1AJ",
                url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
                charllaUrl: URL(string: "https://dev-player.charlla.io/shoplayer/list/QFuoEZxk1AJ?l=grid")!
            ),
            Movie(
                // title: "Elephant Dream",
                // subtitle: "By Blender Foundation",
                title: "Charlla Dev Shoplayer",
                subtitle: "Shoplayer Key: hNRnNg2AG4x",
                url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!,
                charllaUrl: URL(string: "https://dev-player.charlla.io/shoplayer/hNRnNg2AG4x")!
            ),
        ])
    }
}
