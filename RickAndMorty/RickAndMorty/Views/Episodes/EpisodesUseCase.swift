//
//  EpisodesUseCase.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 4/12/22.
//

import Foundation

protocol EpisodesUseCaseProtocol {
    
}

struct EpisodesUseCase: EpisodesUseCaseProtocol {
    private let repository: EpisodesRepositoryProtocol
    
    init(repository: EpisodesRepositoryProtocol) {
        self.repository = repository
    }
}
