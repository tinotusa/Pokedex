//
//  MoveDamageClass.swift
//  Pokedex
//
//  Created by Tino on 20/8/2022.
//

import Foundation

struct MoveDamageClass: Codable, Hashable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// The description of this resource listed in different languages.
    let descriptions: [Description]
    /// A list of moves that fall into this damage class.
    let moves: [NamedAPIResource]
    /// The name of this resource listed in different languages.
    let names: [Name]
}


extension MoveDamageClass: SearchByNameOrID {
    static func from(name: String) async throws -> MoveDamageClass {
        try await PokeAPI.shared.getData(for: MoveDamageClass.self, fromEndpoint: "move-damage-class/\(name)")
    }
    
    static func from(id: Int) async throws -> MoveDamageClass {
        try await from(name: "\(id)")
    }
}
