//
//  Pokedex.swift
//  Pokedex
//
//  Created by Tino on 23/8/2022.
//

import Foundation

struct Pokedex: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// Whether or not this Pokédex originated in the main series of the video games.
    let isMainSeries: Bool
    /// The description of this resource listed in different languages.
    let descriptions: [Description]
    /// The name of this resource listed in different languages.
    let names: [Name]
    /// A list of Pokémon catalogued in this Pokédex and their indexes.
    let pokemonEntries: [PokemonEntry]
    /// The region this Pokédex catalogues Pokémon for.
    let region: NamedAPIResource?
    /// A list of version groups this Pokédex is relevant to.
    let versionGroups: [NamedAPIResource]
}

extension Pokedex: SearchByNameOrID {
    static func from(name: String) async throws -> Pokedex {
        try await PokeAPI.shared.getData(for: Pokedex.self, fromEndpoint: "pokedex/\(name)")
    }
    
    static func from(id: Int) async throws -> Pokedex {
        try await from(name: "\(id)")
    }
}
