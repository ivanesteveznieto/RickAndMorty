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
    private let stateSubject = PassthroughSubject<CharactersCollectionViewController.State, Never>()
    private var characters = [CharacterRepresentable]()
    private var currentStatusFilter: CharacterStatus?
    var statePublisher: AnyPublisher<CharactersCollectionViewController.State, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    init(dependencies: CharactersDependenciesResolver) {
        useCase = dependencies.resolve()
        coordinator = dependencies.resolve()
    }
    
    func getCharacters(status: CharacterStatus? = nil) {
        currentStatusFilter = status
        stateSubject.send(.loading)
        resetView()
        
        Task {
            let result = await useCase.getCharacters(status: status)
            handleCharactersResponse(result)
        }
    }
    
    func getMoreCharacters() {
        stateSubject.send(.loading)
        guard let nextUrl else {
            stateSubject.send(.noMoreCharacters)
            return
        }
        
        Task {
            let result = await useCase.getCharactersFromUrl(nextUrl)
            handleCharactersResponse(result, paging: true)
        }
    }
    
    func retryGetCharacters() {
        if nextUrl != nil {
            getMoreCharacters()
        } else {
            getCharacters(status: currentStatusFilter)
        }
    }
    
    func characterSelected(_ index: Int) {
        coordinator.goToEpisodesScreen(character: characters[index])
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
            stateSubject.send(.data(characterModels))
        case .failure(let error):            
            switch error {
            case .error(let error):
                stateSubject.send(.error(error.localizedDescription))
            case .decoding:
                stateSubject.send(.error("Error en parseo de respuesta"))
            case .badUrl:
                stateSubject.send(.error("Error en formato url"))
            }
        }
    }
    
    func resetView() {
        characters.removeAll()
        nextUrl = nil
        stateSubject.send(.idle)
    }
}
