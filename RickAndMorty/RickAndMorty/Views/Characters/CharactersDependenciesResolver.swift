//
//  CharactersDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 2/12/22.
//

import Foundation
import UIKit

protocol CharactersDependenciesResolver {
    func resolve() -> NetworkManagerProtocol
    func resolve() -> CharactersCoordinatorProtocol
    func resolve() -> CharactersRepositoryProtocol
    func resolve() -> CharactersUseCaseProtocol
    func resolve() -> CharactersViewModel
    func resolve() -> UIViewController
}
