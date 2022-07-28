//
//  PalParkEncounterArea.swift
//  Pokedex
//
//  Created by Tino on 28/7/2022.
//

import Foundation

struct PalParkEncounterArea: Codable, Hashable {
    /// The base score given to the player when the referenced Pokémon is caught during a pal park run.
    let baseScore: Int
    /// The base rate for encountering the referenced Pokémon in this pal park area.
    let rate: Int
    /// The pal park area where this encounter happens.
    let area: NamedAPIResource
    
    enum CodingKeys: String, CodingKey {
        case baseScore = "base_score"
        case rate
        case area
    }
}
