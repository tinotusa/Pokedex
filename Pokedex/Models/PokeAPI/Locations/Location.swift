//
//  Location.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import Foundation

struct Location: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// The region this location can be found in.
    let region: NamedAPIResource
    /// The name of this resource listed in different languages.
    let names: [Name]
    /// A list of game indices relevent to this location by generation.
    let gameIndices: [GenerationGameIndex]
    /// Areas that can be found within this location.
    let areas: [NamedAPIResource]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case region
        case names
        case gameIndices = "game_indices"
        case areas
    }
}

// MARK: SearchByNameOrID conformance
extension Location: SearchByNameOrID {
    static func from(name: String) async throws -> Location {
        try await PokeAPI.shared.getData(for: Location.self, fromEndpoint: "location/\(name)")
    }
    
    static func from(id: Int) async throws -> Location {
        try await from(name: "\(id)")
    }
}
