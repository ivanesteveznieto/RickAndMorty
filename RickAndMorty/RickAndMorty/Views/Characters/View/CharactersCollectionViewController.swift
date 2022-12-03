//
//  CharactersCollectionViewController.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 2/12/22.
//

import UIKit

final class CharactersCollectionViewController: UICollectionViewController {
    private let numberOfItemsPerRow = 4
    private let viewModel: CharactersViewModel
    
    init(viewModel: CharactersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "CharactersCollectionViewController", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // TODO: viewModel.getCharacters()
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
    func setupView() {
        collectionView.register(UINib(nibName: "\(CharacterCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(CharacterCollectionViewCell.self)")
    }
}

extension CharactersCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = Int(collectionView.bounds.width / CGFloat(numberOfItemsPerRow))
        return CGSize(width: size, height: size * 2)
    }
}
