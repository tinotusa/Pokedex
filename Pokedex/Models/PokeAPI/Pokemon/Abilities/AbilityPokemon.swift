//
//  AbilityPokemon.swift
//  Pokedex
//
//  Created by Tino on 20/8/2022.
//

import Foundation

struct AbilityPokemon: Codable, Hashable {
    /// Whether or not this a hidden ability for the referenced Pokémon.
    let isHidden: Bool
    /// Pokémon have 3 ability 'slots' which hold references to possible abilities
    /// they could have. This is the slot of this ability for the referenced pokemon.
    let slot: Int
    /// The Pokémon this ability could belong to.
    let pokemon: NamedAPIResource
}
