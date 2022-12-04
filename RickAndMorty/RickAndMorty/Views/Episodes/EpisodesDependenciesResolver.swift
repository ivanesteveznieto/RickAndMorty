//
//  EpisodesDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 4/12/22.
//

import Foundation
import UIKit

protocol EpisodesDependenciesResolver {
    func resolve() -> NetworkManagerProtocol
    func resolve() -> EpisodesCoordinatorProtocol
    func resolve() -> EpisodesRepositoryProtocol
    func resolve() -> EpisodesUseCaseProtocol
    func resolve() -> EpisodesViewModel
    func resolve() -> UIViewController
}
