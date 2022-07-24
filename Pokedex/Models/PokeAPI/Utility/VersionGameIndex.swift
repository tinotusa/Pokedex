//
//  VersionGameIndex.swift
//  Pokedex
//
//  Created by Tino on 24/7/2022.
//

import Foundation

struct VersionGameIndex: Codable, Hashable {
    let gameIndex: Int
    let version: NamedAPIResource
    
    enum CodingKeys: String, CodingKey {
        case gameIndex = "game_index"
        case version
    }
}
