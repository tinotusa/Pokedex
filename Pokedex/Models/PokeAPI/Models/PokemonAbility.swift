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
    let ability: AbilityDetails
    
    enum CodingKeys: String, CodingKey {
        case isHidden = "is_hidden"
        case slot
        case ability
    }
}
