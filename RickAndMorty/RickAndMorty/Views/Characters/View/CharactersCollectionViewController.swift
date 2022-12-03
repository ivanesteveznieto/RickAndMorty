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
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 7 } // TODO
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CharacterCollectionViewCell.self)", for: indexPath) as? CharacterCollectionViewCell else { return UICollectionViewCell() }
        cell.bind(CharacterCollectionViewCell.Binder(imageUrl: "",
                                                     name: "",
                                                     planet: "",
                                                     status: ""))
        return cell
    }
}

// MARK: Private methods
private extension CharactersCollectionViewController {
    func bind() {
        viewModel.charactersFailurePublisher.sink { _ in
            // TODO: Show error
        }.store(in: &subscriptions)
    }
    
    func setupView() {
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
