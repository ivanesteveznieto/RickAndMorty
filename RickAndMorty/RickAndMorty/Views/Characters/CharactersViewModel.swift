//
//  CharactersViewModel.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 2/12/22.
//

import Foundation

final class CharactersViewModel {
    private let useCase: CharactersUseCaseProtocol
    private let coordinator: CharactersCoordinatorProtocol
    
    init(dependencies: CharactersDependenciesResolver) {
        useCase = dependencies.resolve()
        coordinator = dependencies.resolve()
    }
    
    func getCharacters() {
        Task {
            let result = await useCase.getCharacters()
            // TODO
            switch result {
            case .success(let result): break
            case .failure(let error):
                switch error {
                case .badUrl: break
                case .noData: break
                case .decoding: break
                }
            }
        }
    }
}
