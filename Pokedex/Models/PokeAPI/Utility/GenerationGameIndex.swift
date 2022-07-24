//
//  GenerationGameIndex.swift
//  Pokedex
//
//  Created by Tino on 24/7/2022.
//

import Foundation

struct GenerationGameIndex: Codable, Hashable {
    /// The internal id of an API resource within game data.
    let gameIndex: Int
    /// The generation relevent to this game index.
    let generation: NamedAPIResource
    
    enum CodingKeys: String, CodingKey {
        case gameIndex = "game_index"
        case generation
    }
}
