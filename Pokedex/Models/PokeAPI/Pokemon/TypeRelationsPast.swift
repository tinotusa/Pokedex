//
//  TypeRelationsPast.swift
//  Pokedex
//
//  Created by Tino on 24/7/2022.
//

import Foundation

struct TypeRelationsPast: Codable, Hashable {
    /// The last generation in which the referenced type had the listed damage relations.
    let generation: NamedAPIResource
    /// The damage relations the referenced type had up to and including the listed generation.
    let damageRelations: TypeRelations
    
    enum CodingKeys: String, CodingKey {
        case generation
        case damageRelations = "damage_relations"
    }
}
