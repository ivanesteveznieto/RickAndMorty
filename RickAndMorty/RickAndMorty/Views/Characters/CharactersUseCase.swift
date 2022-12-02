//
//  CharactersUseCase.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 2/12/22.
//

import Foundation

protocol CharactersUseCaseProtocol {
    func getCharacters() async -> Result<CharactersResultRepresentable, NetworkError>
}

struct CharactersUseCase: CharactersUseCaseProtocol {
    private let repository: CharactersRepositoryProtocol
    
    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }
    
    func getCharacters() async -> Result<CharactersResultRepresentable, NetworkError> {
        await repository.getCharacters()
    }
}
