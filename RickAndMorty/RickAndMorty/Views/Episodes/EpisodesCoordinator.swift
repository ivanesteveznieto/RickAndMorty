//
//  EpisodesCoordinator.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 4/12/22.
//

import Foundation
import UIKit

protocol EpisodesCoordinatorProtocol: AnyObject {
    var character: CharacterRepresentable? { get }
}

final class EpisodesCoordinator: Coordinator, EpisodesCoordinatorProtocol {
    private weak var navigationController: UINavigationController?
    private lazy var dependency: EpisodesDependenciesResolver = {
        Dependencies(coordinator: self)
    }()
    var character: CharacterRepresentable?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController?.pushViewController(dependency.resolve(), animated: true)
    }
    
    func set(_ character: CharacterRepresentable) -> Self {
        self.character = character
        return self
    }
}

private extension EpisodesCoordinator {
    struct Dependencies: EpisodesDependenciesResolver {
        private unowned let coordinator: EpisodesCoordinatorProtocol
        
        init(coordinator: EpisodesCoordinatorProtocol) {
            self.coordinator = coordinator
        }
        
        func resolve() -> NetworkManagerProtocol { NetworkManager() }
        func resolve() -> EpisodesCoordinatorProtocol { coordinator }
        func resolve() -> EpisodesRepositoryProtocol { EpisodesRepository(networkManager: resolve()) }
        func resolve() -> EpisodesUseCaseProtocol { EpisodesUseCase(repository: resolve()) }
        func resolve() -> EpisodesViewModel { EpisodesViewModel(dependencies: self, character: coordinator.character!) }
        func resolve() -> UIViewController { EpisodesTableViewController(viewModel: resolve()) }
    }
}
