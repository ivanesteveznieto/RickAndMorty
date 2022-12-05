//
//  EpisodesRepository.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 4/12/22.
//

import Foundation

protocol EpisodesRepositoryProtocol {
    func getEpisodeFromUrl(_ url: String) async -> Result<EpisodeRepresentable, NetworkError>
}

struct EpisodesRepository: EpisodesRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func getEpisodeFromUrl(_ url: String) async -> Result<EpisodeRepresentable, NetworkError> {
        do {
            let data = try await networkManager.get(fullUrl: url).get()
            return decodeResult(data)
        } catch let error as NSError {
            return .failure(.error(error))
        }
    }
}

private extension EpisodesRepository {
    func decodeResult(_ data: Data) -> Result<EpisodeRepresentable, NetworkError> {
        do {
            let result = try JSONDecoder().decode(EpisodeDTO.self, from: data)
            return .success(result)
        } catch {
            return .failure(.decoding)
        }
    }
}
