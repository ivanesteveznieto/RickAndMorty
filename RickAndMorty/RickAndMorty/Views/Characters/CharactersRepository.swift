//
//  CharactersRepository.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 2/12/22.
//

import Foundation

protocol CharactersRepositoryProtocol {
    func getCharacters() async -> Result<CharactersResultRepresentable, NetworkError>
}

struct CharactersRepository: CharactersRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func getCharacters() async -> Result<CharactersResultRepresentable, NetworkError> {
        do {
            let data = try await networkManager.get(path: "character").get()
            let result = try JSONDecoder().decode(CharactersResultDTO.self, from: data)
            return .success(result)
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.decoding)
        }
    }
}
