//
//  GrowthRate.swift
//  Pokedex
//
//  Created by Tino on 22/8/2022.
//

import Foundation

struct GrowthRate: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// The formula used to calculate the rate at which the Pokémon species gains level.
    let formula: String
    /// The descriptions of this characteristic listed in different languages.
    let descriptions: [Description]
    /// A list of levels and the amount of experienced needed to atain them based on this growth rate.
    let levels: [GrowthRateExperienceLevel]
    /// A list of Pokémon species that gain levels at this growth rate.
    let pokemonSpecies: [NamedAPIResource]
}


extension GrowthRate: SearchByNameOrID {
    static func from(name: String) async throws -> GrowthRate {
        try await PokeAPI.shared.getData(for: GrowthRate.self, fromEndpoint: "growth-rate/\(name)")
    }
    
    static func from(id: Int) async throws -> GrowthRate {
        try await from(name: "\(id)")
    }
}
