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
    private let loadingSubject = PassthroughSubject<Void, Never>()
    private let charactersLoadedSubject = PassthroughSubject<[Character], Never>()
    private let charactersFailureSubject = PassthroughSubject<String?, Never>()
    private let noMoreCharactersSubject = PassthroughSubject<Void, Never>()
    private var characters = [CharacterRepresentable]()
    var loadingPublisher: AnyPublisher<Void, Never> {
        loadingSubject.eraseToAnyPublisher()
    }
    var charactersLoadedPublisher: AnyPublisher<[Character], Never> {
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
        loadingSubject.send()
        characters.removeAll()
        
        Task {
            let result = await useCase.getCharacters(status: status)
            handleCharactersResponse(result)
        }
    }
    
    func getMoreCharacters() {
        loadingSubject.send()
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
            characters += result.characters
            let characterModels = characters.sorted(by: { $0.id < $1.id }).map({ Character($0) })
            charactersLoadedSubject.send(characterModels)
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
