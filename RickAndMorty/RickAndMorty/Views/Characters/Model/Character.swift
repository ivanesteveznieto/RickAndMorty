//
//  Character.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 3/12/22.
//

import Foundation

struct Character {
    private let representable: CharacterRepresentable
    
    init(_ representable: CharacterRepresentable) {
        self.representable = representable
    }
    
    var imageUrl: String { representable.image }
    var name: String { representable.name }
    var planet: String { representable.species }
    var status: String { representable.status.rawValue.capitalized }
}
