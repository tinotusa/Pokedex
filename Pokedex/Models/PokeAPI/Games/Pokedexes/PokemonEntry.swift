//
//  PokemonEntry.swift
//  Pokedex
//
//  Created by Tino on 23/8/2022.
//

import Foundation

struct PokemonEntry: Codable, Hashable {
    /// The index of this Pokémon species entry within the Pokédex.
    let entryNumber: Int
    /// The Pokémon species being encountered.
    let pokemonSpecies: NamedAPIResource
}
