//
//  CharactersCollectionViewController.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 2/12/22.
//

import UIKit
import Combine

final class CharactersCollectionViewController: UICollectionViewController {
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private let numberOfItemsPerRow = 4
    private let viewModel: CharactersViewModel
    private var subscriptions = Set<AnyCancellable>()
    private var characters = [Character]()
    private var isLoadingCharacters: Bool {
        activityIndicatorView.isAnimating
    }
    private lazy var filterMenuItems: [UIAction] = {
        return [
            UIAction(title: "Alive", handler: { [unowned viewModel] _ in
                viewModel.getCharacters(status: .alive)
            }),
            UIAction(title: "Dead", handler: { [unowned viewModel] _ in
                viewModel.getCharacters(status: .dead)
            }),
            UIAction(title: "Unknown", handler: { [unowned viewModel] _ in
                viewModel.getCharacters(status: .unknown)
            }),
            UIAction(title: "Any", handler: { [unowned viewModel] _ in
                viewModel.getCharacters()
            })
        ]
    }()
    private lazy var filterMenu: UIMenu = {
        return UIMenu(title: "Filter by status", children: filterMenuItems)
    }()
    
    init(viewModel: CharactersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "CharactersCollectionViewController", bundle: .main)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.getCharacters()
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { characters.count }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CharacterCollectionViewCell.self)", for: indexPath) as? CharacterCollectionViewCell else { return UICollectionViewCell() }
        let character = characters[indexPath.row]
        cell.bind(CharacterCollectionViewCell.Binder(imageUrl: character.imageUrl,
                                                     name: character.name,
                                                     planet: character.planet,
                                                     status: character.status))
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == characters.count - 1 {
            viewModel.getMoreCharacters()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isLoadingCharacters {
            viewModel.characterSelected(indexPath.row)
        }
    }
}

// MARK: Private methods
private extension CharactersCollectionViewController {
    func bind() {
        viewModel.loadingPublisher.sink { [unowned self] _ in
            showLoading()
        }.store(in: &subscriptions)
        
        viewModel.charactersLoadedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] characters in
                self.characters = characters
                collectionView.reloadData()
                hideLoading()
            }.store(in: &subscriptions)
        
        viewModel.charactersFailurePublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] errorDescription in
                hideLoading()
                showErrorAlert(errorDescription)
            }.store(in: &subscriptions)
        
        viewModel.noMoreCharactersPublisher.sink { [unowned self] _ in
            hideLoading()
        }.store(in: &subscriptions)
        
        viewModel.resetViewPublisher.sink { [unowned self] in
            characters.removeAll()
            collectionView.reloadData()
        }.store(in: &subscriptions)
    }
    
    func setupView() {
        title = "Characters"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", menu: filterMenu)

        setupActivityIndicatorView()
        setupCollectionView()
    }
    
    func setupActivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = .systemBlue
        activityIndicatorView.center = view.center
    }
    
    func setupCollectionView() {
        collectionView.register(UINib(nibName: "\(CharacterCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(CharacterCollectionViewCell.self)")
    }
    
    func showLoading() {
        activityIndicatorView.startAnimating()
    }
    
    func hideLoading() {
        activityIndicatorView.stopAnimating()
    }
    
    func showErrorAlert(_ errorDescription: String) {
        let alertController = UIAlertController(title: "Error",
                                                message: errorDescription,
                                                preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.viewModel.retryGetCharacters()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(retryAction)
        present(alertController, animated: true)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CharactersCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = Int(collectionView.bounds.width / CGFloat(numberOfItemsPerRow))
        return CGSize(width: size, height: size * 2)
    }
}
