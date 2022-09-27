//
//  PokemonAbility.swift
//  Pokedex
//
//  Created by Tino on 16/7/2022.
//

import Foundation

struct PokemonAbility: Codable, Hashable {
    let isHidden: Bool
    let slot: Int
    let ability: NamedAPIResource
}
