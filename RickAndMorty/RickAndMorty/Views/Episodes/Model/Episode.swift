//
//  Episode.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 5/12/22.
//

import Foundation

struct Episode {
    private let representable: EpisodeRepresentable
    private let serverFormatter = DateFormatter()
    private let dateFormatter = DateFormatter()

    init(_ representable: EpisodeRepresentable) {
        self.representable = representable
        serverFormatter.dateFormat = "MMMM d, yyyy"
        serverFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: "ES")
    }
    
    var title: String { representable.title }
    
    var airDate: String {
        guard let date = serverFormatter.date(from: representable.airDate) else { return "-" }
        return dateFormatter.string(from: date)
    }
    
    var season: Int? {
        var seasonPrefix = String(representable.season.prefix(3))
        seasonPrefix.removeFirst()
        return Int(seasonPrefix)
    }
}
