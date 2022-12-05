//
//  Season.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 5/12/22.
//

import Foundation

struct Season {
    private let number: Int
    private let episodes: [Episode]
    
    init(number: Int, episodes: [Episode]) {
        self.number = number
        self.episodes = episodes
    }
    
    var seasonName: String { "Season " + "\(number)" }
}
