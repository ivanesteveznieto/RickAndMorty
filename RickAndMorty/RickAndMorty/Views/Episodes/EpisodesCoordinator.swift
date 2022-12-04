//
//  EpisodesCoordinator.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 4/12/22.
//

import Foundation
import UIKit

protocol EpisodesCoordinatorProtocol: AnyObject {
    
}

final class EpisodesCoordinator {
    private weak var navigationController: UINavigationController?
    private lazy var dependency: EpisodesDependenciesResolver = {
        Dependencies(coordinator: self)
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController?.pushViewController(dependency.resolve(), animated: true)
    }
}

extension EpisodesCoordinator: EpisodesCoordinatorProtocol {
    
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
        func resolve() -> EpisodesViewModel { EpisodesViewModel(dependencies: self) }
        func resolve() -> UIViewController { EpisodesTableViewController(viewModel: resolve()) }
    }
}
