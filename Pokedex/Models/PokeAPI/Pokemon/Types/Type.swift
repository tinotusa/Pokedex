//
//  Type.swift
//  Pokedex
//
//  Created by Tino on 24/7/2022.
//

import Foundation

struct `Type`: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// A detail of how effective this type is toward others and vice versa.
    let damageRelations: TypeRelations
    /// A list of details of how effective this type was toward others and vice versa in previous generations.
    let pastDamageRelations: [TypeRelationsPast]
    /// A list of game indices relevent to this item by generation.
    let gameIndices: [GenerationGameIndex]
    /// The generation this type was introduced in.
    let generation: NamedAPIResource
    /// The class of damage inflicted by this type.
    let moveDamageClass: NamedAPIResource?
    /// The name of this resource listed in different languages.
    let names: [Name]
    /// A list of details of Pokémon that have this type.
    let pokemon: [TypePokemon]
    /// A list of moves that have this type.
    let moves: [NamedAPIResource]
}

extension `Type`: SearchByNameOrID {
    static func from(name: String) async throws -> `Type` {
        try await PokeAPI.shared.getData(for: `Type`.self, fromEndpoint: "type/\(name)")
    }
    
    static func from(id: Int) async throws -> `Type` {
        try await Self.from(name: "\(id)")
    }
}
