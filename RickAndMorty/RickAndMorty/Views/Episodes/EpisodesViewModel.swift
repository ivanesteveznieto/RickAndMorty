//
//  EpisodesViewModel.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 4/12/22.
//

import Foundation
import Combine

final class EpisodesViewModel {
    private let useCase: EpisodesUseCaseProtocol
    private let coordinator: EpisodesCoordinatorProtocol
    private let character: CharacterRepresentable
    private let titleSubject = PassthroughSubject<String, Never>()
    private let episodesLoadedSubject = PassthroughSubject<[Season], Never>()
    private var episodesRepresentable = [EpisodeRepresentable]()
    var titlePublisher: AnyPublisher<String, Never> {
        titleSubject.eraseToAnyPublisher()
    }
    var episodesLoadedPublisher: AnyPublisher<[Season], Never> {
        episodesLoadedSubject.eraseToAnyPublisher()
    }
    
    init(dependencies: EpisodesDependenciesResolver, character: CharacterRepresentable) {
        useCase = dependencies.resolve()
        coordinator = dependencies.resolve()
        self.character = character
    }
    
    func viewDidLoad() {
        titleSubject.send(character.name)
        getAllEpisodes()
    }
}

private extension EpisodesViewModel {
    func getAllEpisodes() {
        Task {
            let results = await performEpisodes()
            results.forEach({ handleEpisodeResponse($0) })
            let episodes = episodesRepresentable.map({ Episode($0) }).filter({ $0.season != nil })
            let dictionary = Dictionary(grouping: episodes, by: { $0.season })
            var seasons = [Season]()
            for key in dictionary.keys {
                let season = Season(number: key ?? 0, episodes: dictionary[key] ?? [])
                seasons.append(season)
            }
            episodesLoadedSubject.send(seasons)
        }
    }
    
    func performEpisodes() async -> [Result<EpisodeRepresentable, NetworkError>] {
        var results = [Result<EpisodeRepresentable, NetworkError>]()
        for episode in character.episodes {
            let episodeResult = await useCase.getEpisodeFromUrl(episode)
            results.append(episodeResult)
        }
        return results
    }
    
    func handleEpisodeResponse(_ result: Result<EpisodeRepresentable, NetworkError>) {
        switch result {
        case .success(let episode):
            episodesRepresentable.append(episode)
        case .failure: break
        }
    }
}
