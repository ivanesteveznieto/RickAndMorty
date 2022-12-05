//
//  EpisodeResultDTO.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 2/12/22.
//

import Foundation

struct EpisodeDTO: Decodable {
    let name: String
    let airDate: String
    let episode: String
    
    private enum CodingKeys: String, CodingKey {
        case name, airDate = "air_date", episode
    }
}

extension EpisodeDTO: EpisodeRepresentable {
    var title: String { name }
    var season: String { episode }
}
