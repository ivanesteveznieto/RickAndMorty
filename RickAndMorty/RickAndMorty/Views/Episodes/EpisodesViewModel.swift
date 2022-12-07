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
    private let stateSubject = PassthroughSubject<EpisodesTableViewController.State, Never>()
    var titlePublisher: AnyPublisher<String, Never> {
        titleSubject.eraseToAnyPublisher()
    }
    var statePublisher: AnyPublisher<EpisodesTableViewController.State, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    init(dependencies: EpisodesDependenciesResolver, character: CharacterRepresentable) {
        useCase = dependencies.resolve()
        coordinator = dependencies.resolve()
        self.character = character
    }
    
    func viewDidLoad() {
        titleSubject.send(character.name)
        stateSubject.send(.loading)
        getAllEpisodes()
    }
}

// MARK: Private methods
private extension EpisodesViewModel {
    func getAllEpisodes() {
        Task {
            let episodesResult = await performEpisodes()
            let episodesRepresentable = handleEpisodeResponse(episodesResult)

            let episodes = episodesRepresentable.map({ Episode($0) }).filter({ $0.season != nil })
            
            let seasons = clasifyEpisodesInSeasons(episodes).sorted(by: { $0.number < $1.number })
            stateSubject.send(.data(seasons))
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
    
    func handleEpisodeResponse(_ episodesResult: [Result<EpisodeRepresentable, NetworkError>]) -> [EpisodeRepresentable] {
        var episodesRepresentable = [EpisodeRepresentable]()
        
        episodesResult.forEach { result in
            switch result {
            case .success(let episode):
                episodesRepresentable.append(episode)
            case .failure: break
            }
        }
        return episodesRepresentable
    }
    
    func clasifyEpisodesInSeasons(_ episodes: [Episode]) -> [Season] {
        let episodesDictionary = Dictionary(grouping: episodes, by: { $0.season })
        
        var seasons = [Season]()
        episodesDictionary.keys.forEach({ key in
            let season = Season(number: key ?? 0, episodes: episodesDictionary[key] ?? [])
            seasons.append(season)
        })
        
        return seasons
    }
}
