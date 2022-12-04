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
        showLoading()
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
            activityIndicatorView.startAnimating()
            viewModel.getMoreCharacters()
        }
    }
}

// MARK: Private methods
private extension CharactersCollectionViewController {
    func bind() {
        viewModel.charactersLoadedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] characters in
                activityIndicatorView.stopAnimating()
                self.characters = characters
                collectionView.reloadData()
            }.store(in: &subscriptions)
        
        viewModel.charactersFailurePublisher.sink { _ in
            // TODO: Show error
        }.store(in: &subscriptions)
        
        viewModel.noMoreCharactersPublisher.sink { [unowned activityIndicatorView] _ in
            activityIndicatorView.stopAnimating()
        }.store(in: &subscriptions)
    }
    
    func setupView() {
        title = "Characters"
        activityIndicatorView.hidesWhenStopped = true
        collectionView.register(UINib(nibName: "\(CharacterCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(CharacterCollectionViewCell.self)")
    }
    
    func showLoading() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        activityIndicatorView.center = view.center
    }
}

extension CharactersCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = Int(collectionView.bounds.width / CGFloat(numberOfItemsPerRow))
        return CGSize(width: size, height: size * 2)
    }
}
