//
//  Pokemon.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

/// A pokemon result from PokeAPI.co
struct Pokemon: Identifiable, Hashable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// The base experience gained for defeating this Pokémon.
    let baseExperience: Int
    /// The height of this Pokémon in decimetres.
    let height: Int
    /// Set for exactly one Pokémon used as the default for each species.
    let isDefault: Bool
    /// Order for sorting. Almost national order, except families are grouped together.
    let order: Int
    /// The weight of this Pokémon in hectograms.
    let weight: Int
    /// A list of abilities this Pokémon could potentially have.
    let abilities: [PokemonAbility]
    /// A list of forms this Pokémon can take on.
    let forms: [NamedAPIResource]
    /// A list of game indices relevent to Pokémon item by generation.
    let gameIndices: [VersionGameIndex]
    /// A list of items this Pokémon may be holding when encountered.
    let heldItems: [PokemonHeldItem]
    /// A link to a list of location areas, as well as encounter details pertaining to specific versions.
    let locationAreaEncounters: String
    /// A list of moves along with learn methods and level details pertaining to specific version groups.
    let moves: [PokemonMove]
    /// A list of details showing types this pokémon had in previous generations
    let pastTypes: [PokemonTypePast]
    /// A set of sprites used to depict this Pokémon in the game.
    let sprites: PokemonSprites
    /// The species this Pokémon belongs to.
    let species: NamedAPIResource
    /// A list of base stat values for this Pokémon.
    let stats: [PokemonStat]
    /// A list of details showing types this Pokémon has.
    let types: [PokemonType]
}

// MARK: - SearchByNameOrID conformance
extension Pokemon: SearchByNameOrID {
    static func from(name: String) async -> Pokemon? {
        try? await PokeAPI.getData(for: Pokemon.self, fromEndpoint: "pokemon/\(name)")
    }
    
    static func from(id: Int) async -> Pokemon? {
        return await Self.from(name: "\(id)")
    }
}

// MARK: - Helpers
extension Pokemon {
    /// Returns the localized name for the pokemon.
    func localizedName(preferredLanguage: String = "en") async -> String {
        guard let species = await PokemonSpecies.fromName(name: self.name) else {
            return "error"
        }
        let availableLanguageCodes = species.names.map { name in
            name.language.name
        }
        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguageCodes).first!
        let matchedName = species.names.first { name in
            name.language.name == deviceLanguageCode
        }
        return matchedName?.name ?? self.name
    }
    
    /// Returns an array of all the pokemons types
    func getTypes() -> [String] {
        types.map { type in
            type.type.name
        }
    }
    /// Returns the first types color from xcassets.
    var primaryTypeColour: Color {
        Color(types.first!.type.name)
    }
    /// The sum of all the pokemons stats.
    var totalStats: Int {
        let statValues = stats.map { stat in
            stat.baseStat
        }
        return statValues.reduce(0, +)
    }
    /// The official artwork url for this pokemon's image.
    var officialArtWork: URL? {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
    }
    
    /// An example pokemon for xcode previews.
    static var example: Pokemon {
        let examplePokemonURL = Bundle.main.url(forResource: "ExamplePokemonJSON", withExtension: nil)!
        do {
            let data = try Data(contentsOf: examplePokemonURL)
            let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
            return pokemon
        } catch {
            print("Error")
        }
        fatalError("Couldn't read the default pokemon json file")
    }
}

// MARK: - Equatable conformance
extension Pokemon: Equatable {
    static func ==(lhs: Pokemon, rhs: Pokemon) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Codable conformance
extension Pokemon: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case baseExperience = "base_experience"
        case height
        case isDefault = "is_default"
        case order
        case weight
        case abilities
        case forms
        case gameIndices = "game_indices"
        case heldItems = "held_items"
        case locationAreaEncounters = "location_area_encounters"
        case moves
        case pastTypes = "past_types"
        case sprites
        case species
        case stats
        case types
    }
}

