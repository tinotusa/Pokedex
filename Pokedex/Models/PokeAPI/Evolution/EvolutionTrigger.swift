//
//  EvolutionTrigger.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import Foundation

struct EvolutionTrigger: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// The name of this resource listed in different languages.
    let names: [Name]
    /// A list of pokemon species that result from this evolution trigger.
    let pokemonSpecies: [NamedAPIResource]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case names
        case pokemonSpecies = "pokemon_species"
    }
}

// MARK: SearchByNameOrID conformance
extension EvolutionTrigger: SearchByNameOrID {
    static func from(name: String) async throws -> EvolutionTrigger {
        try await PokeAPI.shared.getData(for: EvolutionTrigger.self, fromEndpoint: "evolution-trigger/\(name)")
    }
    
    static func from(id: Int) async throws -> EvolutionTrigger {
        try await from(name: "\(id)")
    }
}
