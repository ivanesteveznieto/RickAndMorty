//
//  NetworkManager.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 1/12/22.
//

import Foundation

protocol NetworkManagerProtocol {
    func get(path: String) async -> Result<Data, NetworkError>
}

struct NetworkManager: NetworkManagerProtocol {
    private let baseUrl = "https://rickandmortyapi.com/api/"
    
    func get(path: String) async -> Result<Data, NetworkError> {
        guard let url = URL(string: baseUrl + path) else { return .failure(.badUrl) }
        let request = URLRequest(url: url)
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return .success(data)
        } catch {
            return .failure(.noData)
        }
    }
}
