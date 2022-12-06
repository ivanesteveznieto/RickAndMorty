//
//  CharactersCoordinator.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 2/12/22.
//

import Foundation
import UIKit

protocol Coordinator {
    func start()
}

protocol CharactersCoordinatorProtocol: AnyObject {
    func goToEpisodesScreen(character: CharacterRepresentable)
}

final class CharactersCoordinator: Coordinator {
    private weak var navigationController: UINavigationController?
    private lazy var dependency: CharactersDependenciesResolver = {
        Dependencies(coordinator: self)
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController?.pushViewController(dependency.resolve(), animated: true)
    }
}

extension CharactersCoordinator: CharactersCoordinatorProtocol {
    func goToEpisodesScreen(character: CharacterRepresentable) {
        let coordinator = EpisodesCoordinator(navigationController: navigationController)
        coordinator
            .set(character)
            .start()
    }
}

private extension CharactersCoordinator {
    struct Dependencies: CharactersDependenciesResolver {
        private unowned let coordinator: CharactersCoordinatorProtocol
        
        init(coordinator: CharactersCoordinatorProtocol) {
            self.coordinator = coordinator
        }
        
        func resolve() -> NetworkManagerProtocol { NetworkManager() }
        func resolve() -> CharactersCoordinatorProtocol { coordinator }
        func resolve() -> CharactersRepositoryProtocol { CharactersRepository(networkManager: resolve()) }
        func resolve() -> CharactersUseCaseProtocol { CharactersUseCase(repository: resolve()) }
        func resolve() -> CharactersViewModel { CharactersViewModel(dependencies: self) }
        func resolve() -> UIViewController { CharactersCollectionViewController(viewModel: resolve()) }
    }
}
