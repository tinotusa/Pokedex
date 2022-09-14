//
//  PokemonHeldItem.swift
//  Pokedex
//
//  Created by Tino on 24/7/2022.
//

import Foundation

struct PokemonHeldItem: Codable, Hashable {
    // The item the referenced Pokemon holds.
    let item: NamedAPIResource
    /// The details of the different versions in which the item is held.
    let versionDetails: [PokemonHeldItemVersion]
}

struct PokemonHeldItemVersion: Codable, Hashable {
    /// The version in which the item is held.
    let version: NamedAPIResource
    /// How often the item is held.
    let rarity: Int
}
