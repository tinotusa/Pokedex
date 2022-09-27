//
//  Region.swift
//  Pokedex
//
//  Created by Tino on 21/9/2022.
//

import Foundation

struct Region: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// A list of locations that can be found in this region.
    let locations: [NamedAPIResource]
    /// The name for this resource.
    let name: String
    /// The name of this resource listed in different languages.
    let names: [Name]
    /// The generation this region was introduced in.
    let mainGeneration: NamedAPIResource
    /// A list of pokédexes that catalogue Pokémon in this region.
    let pokedexes: [NamedAPIResource]
    /// A list of version groups where this region can be visited.
    let versionGroups: [NamedAPIResource]
}

extension Region: SearchByNameOrID {
    static func from(name: String) async throws -> Region {
        return try await PokeAPI.shared.getData(for: Region.self, fromEndpoint: "region/\(name)")
    }
                                                
    static func from(id: Int) async throws -> Region {
        return try await from(name: "\(id)")
    }
}
