//
//  PokemonSpeciesDexEntry.swift
//  Pokedex
//
//  Created by Tino on 28/7/2022.
//

import Foundation

struct PokemonSpeciesDexEntry: Codable, Hashable {
    /// The index number within the Pokédex.
    let entryNumber: Int
    /// The Pokédex the referenced Pokémon species can be found in.
    let pokedex: NamedAPIResource
}
