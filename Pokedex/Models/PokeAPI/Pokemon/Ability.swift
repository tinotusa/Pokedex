//
//  Ability.swift
//  Pokedex
//
//  Created by Tino on 20/8/2022.
//

import SwiftUI

struct Ability: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// Whether or not this ability originated in the main series of the video games.
    let isMainSeries: Bool
    /// The generation this ability originated in.
    let generation: NamedAPIResource
    /// The name of this resource listed in different languages.
    let names: [Name]
    /// The effect of this ability listed in different languages.
    let effectEntries: [VerboseEffect]
    /// The list of previous effects this ability has had across version groups.
    let effectChanges: [AbilityEffectChange]
    /// The flavor text of this ability listed in different languages.
    let flavorTextEntries: [AbilityFlavorText]
    /// A list of Pokémon that could potentially have this ability.
    let pokemon: [AbilityPokemon]
}

// MARK: - SearchByNameOrID conformance
extension Ability: SearchByNameOrID {
    static func from(name: String) async throws -> Ability {
        try await PokeAPI.shared.getData(for: Ability.self, fromEndpoint: "ability/\(name)")
    }
    static func from(id: Int) async throws -> Ability {
        try await Self.from(name: "\(id)")
    }
}

extension Ability: SearchableByURL {
    static func from(url: URL) async throws -> Ability {
        try await PokeAPI.shared.getData(for: Ability.self, url: url)
    }
}
