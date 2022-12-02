//
//  CharacterResult.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 1/12/22.
//

import Foundation

struct CharactersResultDTO: Decodable {
    let info: InfoDTO
    let results: [CharacterDTO]
    
    struct InfoDTO: Decodable {
        let next: String?
    }
}

extension CharactersResultDTO: CharactersResultRepresentable {
    var nextCharactersUrl: String? { info.next }
    var characters: [CharacterRepresentable] { results }
}
