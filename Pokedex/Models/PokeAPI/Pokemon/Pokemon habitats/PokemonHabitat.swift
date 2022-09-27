//
//  PokemonHabitat.swift
//  Pokedex
//
//  Created by Tino on 22/8/2022.
//

import Foundation

struct PokemonHabitat: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// The name of this resource listed in different languages.
    let names: [Name]
    /// A list of the Pokémon species that can be found in this habitat.
    let pokemonSpecies: [NamedAPIResource]
}

extension PokemonHabitat: SearchByNameOrID {
    static func from(name: String) async throws -> Self {
        try await PokeAPI.shared.getData(for: Self.self, fromEndpoint: "pokemon-habitat/\(name)")
    }
    
    static func from(id: Int) async throws -> Self {
        try await from(name: "\(id)")
    }
}
