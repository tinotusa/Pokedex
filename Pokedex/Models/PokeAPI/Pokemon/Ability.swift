//
//  Ability.swift
//  Pokedex
//
//  Created by Tino on 19/7/2022.
//

import SwiftUI

/// The ability of a pokemon (not to be confused with move).
struct Ability: Codable {
    /// The name of the ability
    let name: String
    /// The array of names of the ability in different languages.
    let names: [Name]
}

extension Ability: SearchByNameOrID {
    static func from(name: String) async throws -> Ability {
        try await PokeAPI.shared.getData(for: Ability.self, fromEndpoint: "ability/\(name)")
    }
    static func from(id: Int) async throws -> Ability {
        try await Self.from(name: "\(id)")
    }
}
