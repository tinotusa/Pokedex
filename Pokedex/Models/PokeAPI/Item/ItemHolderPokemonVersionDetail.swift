//
//  ItemHolderPokemonVersionDetail.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import Foundation

struct ItemHolderPokemonVersionDetail: Codable, Hashable {
    /// How often this Pokémon holds this item in this version.
    let rarity: Int
    /// The version that this item is held in by the Pokémon.
    let version: NamedAPIResource
}
