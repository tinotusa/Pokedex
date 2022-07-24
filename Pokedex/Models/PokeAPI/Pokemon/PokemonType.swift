//
//  PokemonType.swift
//  Pokedex
//
//  Created by Tino on 24/7/2022.
//

import Foundation

struct PokemonType: Codable, Hashable {
    /// The order the Pokemon's types are listed in.
    let slot: Int
    /// The type the referenced Form has.
    let type: NamedAPIResource
}
