//
//  EggGroup.swift
//  Pokedex
//
//  Created by Tino on 19/7/2022.
//

import Foundation

struct EggGroup: Codable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// The name of this resource listed in different languages.
    let names: [Name]
    /// A list of all Pokémon species that are members of this egg group.
    let pokemonSpecies: [NamedAPIResource]
}

extension EggGroup: SearchByNameOrID {
    static func from(name: String) async throws -> EggGroup {
        try await PokeAPI.shared.getData(for: EggGroup.self, fromEndpoint: "egg-group/\(name)")
    }
    
    static func from(id: Int) async throws -> EggGroup {
        try await Self.from(name: "\(id)")
    }
}
