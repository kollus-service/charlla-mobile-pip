//
//  Movie.swift
//  PiPlayground
//
//  Created by Tiago Lopes on 01/02/24.
//

import Foundation

struct Movie: Equatable, Hashable {
    let title: String
    let subtitle: String
    let url: URL
    let charllaUrl: URL
}

extension Movie: Identifiable {
    var id: Int { hashValue }
}

extension Movie: CustomStringConvertible {
    var description: String {
        """
        Movie 🎬: \(title), \(subtitle), at \(url.description)
        Charlla: \(charllaUrl.description)
        """
    }
}
