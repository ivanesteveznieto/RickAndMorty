//
//  EpisodesUseCase.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 4/12/22.
//

import Foundation

protocol EpisodesUseCaseProtocol {
    func getEpisodeFromUrl(_ url: String) async -> Result<EpisodeRepresentable, NetworkError>
}

struct EpisodesUseCase: EpisodesUseCaseProtocol {
    private let repository: EpisodesRepositoryProtocol
    
    init(repository: EpisodesRepositoryProtocol) {
        self.repository = repository
    }
    
    func getEpisodeFromUrl(_ url: String) async -> Result<EpisodeRepresentable, NetworkError> {
        await repository.getEpisodeFromUrl(url)
    }
}
