//
//  TypePokemon.swift
//  Pokedex
//
//  Created by Tino on 24/7/2022.
//

import Foundation

struct TypePokemon: Codable, Hashable {
    /// The order the Pokémon's types are listed in.
    let slot: Int
    /// The Pokémon that has the referenced type.
    let pokemon: NamedAPIResource
}
