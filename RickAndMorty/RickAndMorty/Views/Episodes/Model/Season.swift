//
//  Season.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 5/12/22.
//

import Foundation

struct Season {
    let number: Int
    let episodes: [Episode]
    var seasonName: String { "Season " + "\(number)" }
}
