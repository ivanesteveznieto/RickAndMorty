//
//  CharactersResultRepresentable.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 1/12/22.
//

import Foundation

protocol CharactersResultRepresentable {
    var nextCharactersUrl: String? { get }
    var characters: [CharacterRepresentable] { get }
}
