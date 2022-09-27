//
//  Gender.swift
//  Pokedex
//
//  Created by Tino on 22/8/2022.
//

import Foundation

struct Gender: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// A list of Pokémon species that can be this gender and how likely it is that they will be.
    let pokemonSpeciesDetails: [PokemonSpeciesGender]
    /// A list of Pokémon species that required this gender in order for a Pokémon to evolve into them.
    let requiredForEvolution: [NamedAPIResource]
}

extension Gender: SearchByNameOrID {
    static func from(name: String) async throws -> Gender {
        try await PokeAPI.shared.getData(for: Gender.self, fromEndpoint: "gender/\(name)")
    }
    
    static func from(id: Int) async throws -> Gender {
        try await from(name: "\(id)")
    }
}
