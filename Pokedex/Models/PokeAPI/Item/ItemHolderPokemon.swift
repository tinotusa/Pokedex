//
//  ItemHolderPokemon.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import Foundation

struct ItemHolderPokemon: Codable, Hashable {
    /// The Pokémon that holds this item.
    let pokemon: NamedAPIResource
    /// The details for the version that this item is held in by the Pokémon.
    let versionDetails: [ItemHolderPokemonVersionDetail]
    
    enum CodingKeys: String, CodingKey {
        case pokemon
        case versionDetails = "version_details"
    }
}
