//
//  CharacterDTO.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 1/12/22.
//

import Foundation

struct CharacterDTO: Decodable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let image: String
    let species: String
    let episode: [String]
}

extension CharacterDTO: CharacterRepresentable {
    var episodes: [String] { episode }
}

enum CharacterStatus: String, Decodable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
