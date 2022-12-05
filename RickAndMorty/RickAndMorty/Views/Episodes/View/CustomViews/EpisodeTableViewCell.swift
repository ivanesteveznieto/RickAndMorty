//
//  EpisodeTableViewCell.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 5/12/22.
//

import UIKit

final class EpisodeTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var airDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func bind(title: String, airDate: String) {
        titleLabel.text = title
        airDateLabel.text = airDate
    }
}
