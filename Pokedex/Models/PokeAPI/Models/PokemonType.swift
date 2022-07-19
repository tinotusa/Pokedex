//
//  PokemonType.swift
//  Pokedex
//
//  Created by Tino on 18/7/2022.
//

import Foundation

struct PokemonTypeRelations: Codable, Hashable {
    let doubleDamageFrom: [APIResourceType]
    let doubleDamageTo: [APIResourceType]
    
    enum CodingKeys: String, CodingKey {
        case doubleDamageFrom = "double_damage_from"
        case doubleDamageTo = "double_damage_to"
    }
}

struct PokemonType: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    let damageRelations: PokemonTypeRelations
    let names: [Name]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case damageRelations = "damage_relations"
        case names
    }
}
