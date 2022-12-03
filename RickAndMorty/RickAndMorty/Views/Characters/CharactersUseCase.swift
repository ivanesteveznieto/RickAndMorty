//
//  CharactersUseCase.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 2/12/22.
//

import Foundation

protocol CharactersUseCaseProtocol {
    func getCharacters(status: CharacterStatus?) async -> Result<CharactersResultRepresentable, NetworkError>
    func getCharactersFromUrl(_ url: String) async -> Result<CharactersResultRepresentable, NetworkError>
}

struct CharactersUseCase: CharactersUseCaseProtocol {
    private let repository: CharactersRepositoryProtocol
    
    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }
    
    func getCharacters(status: CharacterStatus?) async -> Result<CharactersResultRepresentable, NetworkError> {
        await repository.getCharacters(status: status)
    }
    
    func getCharactersFromUrl(_ url: String) async -> Result<CharactersResultRepresentable, NetworkError> {
        await repository.getCharactersFromUrl(url)
    }
}
