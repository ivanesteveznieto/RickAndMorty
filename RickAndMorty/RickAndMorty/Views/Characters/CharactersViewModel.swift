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
    private var nextUrl: String?
    private let charactersLoadedSubject = PassthroughSubject<CharactersResultRepresentable, Never>()
    private let charactersFailureSubject = PassthroughSubject<String?, Never>()
    private let noMoreCharactersSubject = PassthroughSubject<Void, Never>()
    var charactersLoadedPublisher: AnyPublisher<CharactersResultRepresentable, Never> {
        charactersLoadedSubject.eraseToAnyPublisher()
    }
    var charactersFailurePublisher: AnyPublisher<String?, Never> {
        charactersFailureSubject.eraseToAnyPublisher()
    }
    var noMoreCharactersPublisher: AnyPublisher<Void, Never> {
        noMoreCharactersSubject.eraseToAnyPublisher()
    }
    
    init(dependencies: CharactersDependenciesResolver) {
        useCase = dependencies.resolve()
        coordinator = dependencies.resolve()
    }
    
    func getCharacters(status: CharacterStatus? = nil) {
        Task {
            let result = await useCase.getCharacters(status: status)
            handleCharactersResponse(result)
        }
    }
    
    func getMoreCharacters() {
        guard let nextUrl else {
            noMoreCharactersSubject.send()
            return
        }
        
        Task {
            let result = await useCase.getCharactersFromUrl(nextUrl)
            handleCharactersResponse(result, paging: true)
        }
    }
}

// MARK: Private methods
private extension CharactersViewModel {
    func handleCharactersResponse(_ result: Result<CharactersResultRepresentable, NetworkError>, paging: Bool = false) {
        switch result {
        case .success(let result):
            nextUrl = result.nextCharactersUrl
            
        case .failure(let error):
            guard !paging else { return }
            
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
