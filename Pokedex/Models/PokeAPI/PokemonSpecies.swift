//
//  PokemonSpecies.swift
//  Pokedex
//
//  Created by Tino on 15/7/2022.
//

import SwiftUI

/// The pokemon species details.
struct PokemonSpecies: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// The order in which species should be sorted. Based on National Dex order,
    /// except families are grouped together and sorted by stage.
    let order: Int
    /// The chance of this Pokémon being female, in eighths; or -1 for genderless.
    let genderRate: Int
    /// The base capture rate; up to 255. The higher the number, the easier the catch.
    let captureRate: Int?
    /// The happiness when caught by a normal Pokéball; up to 255. The higher the
    /// number, the happier the Pokémon.
    let baseHappiness: Int?
    /// Whether or not this is a baby Pokémon.
    let isBaby: Bool
    /// Whether or not this is a legendary Pokémon.
    let isLegendary: Bool
    /// Whether or not this is a mythical Pokémon.
    let isMythical: Bool
    /// Initial hatch counter: one must walk 255 × (hatch_counter + 1) steps before this
    /// Pokémon's egg hatches, unless utilizing bonuses like Flame Body's.
    let hatchCounter: Int?
    /// Whether or not this Pokémon has visual gender differences.
    let hasGenderDifferences: Bool
    /// Whether or not this Pokémon has multiple forms and can switch between them.
    let formsSwitchable: Bool
    /// The rate at which this Pokémon species gains levels.
    let growthRate: NamedAPIResource
    /// A list of Pokedexes and the indexes reserved within them for this Pokémon species.
    let pokedexNumbers: [PokemonSpeciesDexEntry]
    /// A list of egg groups this Pokémon species is a member of.
    let eggGroups: [NamedAPIResource]
    /// The color of this Pokémon for Pokédex search.
    let color: NamedAPIResource
    /// The shape of this Pokémon for Pokédex search.
    let shape: NamedAPIResource
    /// The Pokémon species that evolves into this Pokemon_species.
    let evolvesFromSpecies: NamedAPIResource?
    /// The evolution chain this Pokémon species is a member of.
    let evolutionChain: APIResource?
    /// The habitat this Pokémon species can be encountered in.
    let habitat: NamedAPIResource?
    /// The generation this Pokémon species was introduced in.
    let generation: NamedAPIResource
    /// The name of this resource listed in different languages.
    let names: [Name]
    /// A list of encounters that can be had with this Pokémon species in pal park.
    let palParkEncounters: [PalParkEncounterArea]
    /// A list of flavor text entries for this Pokémon species.
    let flavorTextEntries: [FlavorText]
    /// Descriptions of different forms Pokémon take on within the Pokémon species.
    let formDescriptions: [Description]
    /// The genus of this Pokémon species listed in multiple languages.
    let genera: [Genus]
    /// A list of the Pokémon that exist within this Pokémon species.
    let varieties: [PokemonSpeciesVariety]
}

// MARK: - SearchByNameOrID conformance
extension PokemonSpecies: SearchByNameOrID {
    static func from(name: String) async throws -> PokemonSpecies {
        try await PokeAPI.shared.getData(for: PokemonSpecies.self, fromEndpoint: "pokemon-species/\(name)")
    }
    
    static func from(id: Int) async throws -> PokemonSpecies {
        try await from(name: "\(id)")
    }
}

extension PokemonSpecies: SearchableByURL {
    static func from(url: URL) async throws -> PokemonSpecies {
        return try await PokeAPI.shared.getData(for: PokemonSpecies.self, url: url)
    }
}
