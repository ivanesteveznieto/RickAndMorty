//
//  EpisodesRepository.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 4/12/22.
//

import Foundation

protocol EpisodesRepositoryProtocol {
    
}

struct EpisodesRepository: EpisodesRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
}
