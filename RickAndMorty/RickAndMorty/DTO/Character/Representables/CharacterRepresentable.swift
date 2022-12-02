//
//  CharacterRepresentable.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 1/12/22.
//

import Foundation

protocol CharacterRepresentable {
    var id: Int { get }
    var name: String { get }
    var status: CharacterStatus { get }
    var image: String { get }
    var species: String { get }
    var episodes: [String] { get }
}
