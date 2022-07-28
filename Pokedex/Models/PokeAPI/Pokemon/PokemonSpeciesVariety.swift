//
//  PokemonSpeciesVariety.swift
//  Pokedex
//
//  Created by Tino on 28/7/2022.
//

import Foundation

struct PokemonSpeciesVariety: Codable, Hashable {
    /// Whether this variety is the default variety.
    let isDefault: Bool
    /// The Pokémon variety.
    let pokemon: NamedAPIResource
    
    enum CodingKeys: String, CodingKey {
        case isDefault = "is_default"
        case pokemon
    }
}
