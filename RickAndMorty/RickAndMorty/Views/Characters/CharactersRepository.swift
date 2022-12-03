//
//  CharactersRepository.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 2/12/22.
//

import Foundation

protocol CharactersRepositoryProtocol {
    func getCharacters() async -> Result<CharactersResultRepresentable, NetworkError>
    func getCharactersFromUrl(_ url: String) async -> Result<CharactersResultRepresentable, NetworkError>
}

struct CharactersRepository: CharactersRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func getCharacters() async -> Result<CharactersResultRepresentable, NetworkError> {
        do {
            let data = try await networkManager.get(path: "character").get()
            return decodeResult(data)
        } catch let error as NSError {
            return .failure(.error(error))
        }
    }
    
    func getCharactersFromUrl(_ url: String) async -> Result<CharactersResultRepresentable, NetworkError> {
        do {
            let data = try await networkManager.get(fullUrl: url).get()
            return decodeResult(data)
        } catch let error as NSError {
            return .failure(.error(error))
        }
    }
}

// MARK: Private methods
private extension CharactersRepository {
    func decodeResult(_ data: Data) -> Result<CharactersResultRepresentable, NetworkError> {
        do {
            let result = try JSONDecoder().decode(CharactersResultDTO.self, from: data)
            return .success(result)
        } catch {
            return .failure(.decoding)
        }
    }
}
