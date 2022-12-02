//
//  EpisodeRepresentable.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 2/12/22.
//

import Foundation

protocol EpisodeRepresentable {
    var title: String { get }
    var season: String { get }
    var airDate: Date { get }
}
