//
//  EpisodesViewModel.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 4/12/22.
//

import Foundation

final class EpisodesViewModel {
    private let useCase: EpisodesUseCaseProtocol
    private let coordinator: EpisodesCoordinatorProtocol
    
    init(dependencies: EpisodesDependenciesResolver) {
        useCase = dependencies.resolve()
        coordinator = dependencies.resolve()
    }
}
