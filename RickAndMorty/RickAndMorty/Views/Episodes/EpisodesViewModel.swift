//
//  EpisodesViewModel.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 4/12/22.
//

import Foundation
import Combine

final class EpisodesViewModel {
    private let useCase: EpisodesUseCaseProtocol
    private let coordinator: EpisodesCoordinatorProtocol
    private let character: CharacterRepresentable
    private let titleSubject = PassthroughSubject<String, Never>()
    var titlePublisher: AnyPublisher<String, Never> {
        titleSubject.eraseToAnyPublisher()
    }
    
    init(dependencies: EpisodesDependenciesResolver, character: CharacterRepresentable) {
        useCase = dependencies.resolve()
        coordinator = dependencies.resolve()
        self.character = character
    }
    
    func viewDidLoad() {
        titleSubject.send(character.name)
    }
}
