//
//  NetworkManager.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 1/12/22.
//

import Foundation

protocol NetworkManagerProtocol {
    func get(path: String) async -> Result<Data, NetworkError>
    func get(fullUrl: String) async -> Result<Data, NetworkError>
}

struct NetworkManager: NetworkManagerProtocol {
    private let baseUrl = "https://rickandmortyapi.com/api/"
    
    func get(path: String) async -> Result<Data, NetworkError> {
        guard let url = URL(string: baseUrl + path) else { return .failure(.badUrl) }
        return await request(url)
    }
    
    func get(fullUrl: String) async -> Result<Data, NetworkError> {
        guard let url = URL(string: fullUrl) else { return .failure(.badUrl) }
        return await request(url)
    }
}

// MARK: Private methods
private extension NetworkManager {
    func request(_ url: URL) async -> Result<Data, NetworkError> {
        let request = URLRequest(url: url)
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return .success(data)
        } catch let error as NSError {
            return .failure(.error(error))
        }
    }
}
