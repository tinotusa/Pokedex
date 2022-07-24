//
//  PokemonTypePast.swift
//  Pokedex
//
//  Created by Tino on 24/7/2022.
//

import Foundation

struct PokemonTypePast: Codable, Hashable {
    /// The last generation in which the referenced pokemon had the listed types.
    let generation: NamedAPIResource
    /// The types the referenced pokemon had up to and including the listed generation.
    let types: [PokemonType]
}
