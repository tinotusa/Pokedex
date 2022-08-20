//
//  Generation.swift
//  Pokedex
//
//  Created by Tino on 20/8/2022.
//

import Foundation

struct Generation: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// A list of abilities that were introduced in this generation.
    let abilities: [NamedAPIResource]
    /// The name of this resource listed in different languages.
    let names: [Name]
    /// The main region travelled in this generation.
    let mainRegion: NamedAPIResource
    /// A list of moves that were introduced in this generation.
    let moves: [NamedAPIResource]
    /// A list of Pokémon species that were introduced in this generation.
    let pokemonSpecies: [NamedAPIResource]
    /// A list of types that were introduced in this generation.
    let types: [NamedAPIResource]
    /// A list of version groups that were introduced in this generation.
    let versionGroups: [NamedAPIResource]
}

// MARK: - CodingKeys
extension Generation {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case abilities
        case names
        case mainRegion = "main_region"
        case moves
        case pokemonSpecies = "pokemon_species"
        case types
        case versionGroups = "version_groups"
    }
}

// MARK: - Example Generation
extension Generation {
    static var example: Generation {
        do {
            return try Bundle.main.loadJSON(ofType: Generation.self, filename: "generation", extension: "json")
        } catch {
            fatalError("Error in \(#function).\n\(error)")
        }
    }
}

// MARK: - SearchByNameOrID conformance
extension Generation: SearchByNameOrID {
    static func from(name: String) async throws -> Generation {
        try await PokeAPI.shared.getData(for: Generation.self, fromEndpoint: "generation/\(name)")
    }
    
    static func from(id: Int) async throws -> Generation {
        try await from(name: "\(id)")
    }
}
