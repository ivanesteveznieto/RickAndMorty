//
//  CharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 2/12/22.
//

import UIKit

final class CharacterCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var planetLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    
    struct Binder {
        let imageUrl: String
        let name: String
        let planet: String
        let status: String
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func bind(_ binder: Binder) {
        imageView.loadFrom(url: binder.imageUrl, placeholder: UIImage(systemName: "photo"))
        nameLabel.text = binder.name
        planetLabel.text = binder.planet
        statusLabel.text = binder.status
    }
}

private extension CharacterCollectionViewCell {
    func setupView() {
        DispatchQueue.main.async {
            self.imageView.layer.cornerRadius = self.imageView.frame.height / 2.0
        }
    }
}
