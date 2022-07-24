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
    static func fromName(name: String) async -> Ability? {
        try? await PokeAPI.getData(for: Ability.self, fromEndpoint: "ability/\(name)")
    }
    static func fromID(id: Int) async -> Ability? {
        return await Self.fromName(name: "\(id)")
    }
}
