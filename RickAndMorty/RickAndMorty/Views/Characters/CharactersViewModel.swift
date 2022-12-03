//
//  CharactersViewModel.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 2/12/22.
//

import Foundation
import Combine

final class CharactersViewModel {
    private let useCase: CharactersUseCaseProtocol
    private let coordinator: CharactersCoordinatorProtocol
    private let charactersLoadedSubject = PassthroughSubject<CharactersResultRepresentable, Never>()
    private let charactersFailureSubject = PassthroughSubject<String?, Never>()
    var charactersLoadedPublisher: AnyPublisher<CharactersResultRepresentable, Never> {
        charactersLoadedSubject.eraseToAnyPublisher()
    }
    var charactersFailurePublisher: AnyPublisher<String?, Never> {
        charactersFailureSubject.eraseToAnyPublisher()
    }
    
    init(dependencies: CharactersDependenciesResolver) {
        useCase = dependencies.resolve()
        coordinator = dependencies.resolve()
    }
    
    func getCharacters() {
        Task {
            let result = await useCase.getCharacters()
            handleCharactersResponse(result)
        }
    }
}

// MARK: Private methods
private extension CharactersViewModel {
    func handleCharactersResponse(_ result: Result<CharactersResultRepresentable, NetworkError>) {
        switch result {
        case .success(let result):
            break
        case .failure(let error):
            switch error {
            case .error(let error):
                charactersFailureSubject.send(error.localizedDescription)
            case .decoding:
                charactersFailureSubject.send("Error en parseo de respuesta")
            case .badUrl:
                charactersFailureSubject.send("Error en formato url")
            }
        }
    }
}
