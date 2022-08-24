//
//  MoveCategory.swift
//  Pokedex
//
//  Created by Tino on 24/8/2022.
//

import Foundation

struct MoveCategory: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// A list of moves that fall into this category.
    let moves: [NamedAPIResource]
    /// The description of this resource listed in different languages.
    let descriptions: [Description]
}

extension MoveCategory: SearchByNameOrID {
    static func from(name: String) async throws -> MoveCategory {
        try await PokeAPI.shared.getData(for: MoveCategory.self, fromEndpoint: "move-category/\(name)")
    }
    
    static func from(id: Int) async throws -> MoveCategory {
        try await from(name: "\(id)")
    }
}
