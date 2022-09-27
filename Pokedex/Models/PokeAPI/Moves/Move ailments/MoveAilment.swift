//
//  MoveAilment.swift
//  Pokedex
//
//  Created by Tino on 24/8/2022.
//

import Foundation

struct MoveAilment: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// A list of moves that cause this ailment.
    let moves: [NamedAPIResource]
    /// The name of this resource listed in different languages.
    let names: [Name]
}

extension MoveAilment: SearchByNameOrID {
    static func from(name: String) async throws -> MoveAilment {
        try await PokeAPI.shared.getData(for: MoveAilment.self, fromEndpoint: "move-ailment/\(name)")
    }
    
    static func from(id: Int) async throws -> MoveAilment {
        try await from(name: "\(id)")
    }
}
