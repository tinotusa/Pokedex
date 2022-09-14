//
//  VersionGroup.swift
//  Pokedex
//
//  Created by Tino on 14/9/2022.
//

import Foundation

struct VersionGroup: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// Order for sorting. Almost by date of release, except similar versions are grouped together.
    let order: Int
    /// The generation this version was introduced in.
    let generation: NamedAPIResource
    /// A list of methods in which Pokémon can learn moves in this version group.
    let moveLearnMethods: [NamedAPIResource]
    /// A list of Pokédexes introduces in this version group.
    let pokedexes: [NamedAPIResource]
    /// A list of regions that can be visited in this version group.
    let regions: [NamedAPIResource]
    /// The versions this version group owns.
    let versions: [NamedAPIResource]
}

extension VersionGroup: SearchByNameOrID {
    static func from(name: String) async throws -> VersionGroup {
        try await PokeAPI.shared.getData(for: VersionGroup.self, fromEndpoint: "version-group/\(name)")
    }
    
    static func from(id: Int) async throws -> VersionGroup {
        try await from(name: "\(id)")
    }
}
