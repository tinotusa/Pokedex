//
//  SearchableByURL.swift
//  Pokedex
//
//  Created by Tino on 4/9/2022.
//

import Foundation

protocol SearchableByURL {
    associatedtype `Type`: Decodable
    static func from(url: URL) async throws -> `Type`
}
