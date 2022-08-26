//
//  MoveTarget.swift
//  Pokedex
//
//  Created by Tino on 26/8/2022.
//

import Foundation

struct MoveTarget: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// The description of this resource listed in different languages.
    let descriptions: [Description]
    /// A list of moves that that are directed at this target.
    let moves: [NamedAPIResource]
    /// The name of this resource listed in different languages.
    let names: [Name]
}

extension MoveTarget: SearchByNameOrID {
    static func from(name: String) async throws -> MoveTarget {
        try await PokeAPI.shared.getData(for: MoveTarget.self, fromEndpoint: "move-target/\(name)")
    }
    
    static func from(id: Int) async throws -> MoveTarget {
        try await from(name: "\(id)")
    }
}
