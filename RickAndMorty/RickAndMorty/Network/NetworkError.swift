//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 1/12/22.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case decoding
    case noData
}
