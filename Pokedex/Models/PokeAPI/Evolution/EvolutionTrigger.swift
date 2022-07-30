//
//  EvolutionTrigger.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import Foundation

extension Array where Element == Name {
    var localizedName: String? {
//        var availableLanguageCodes = ["en"] // adding something to the front of the array will help keep a safe fallback
        let availableLanguageCodes = self.map { name in
            name.language.name
        }
//        availableLanguageCodes.append(contentsOf: temp)
        // This is assuming PokeAPI always has an available language in the `[Name]` array of a type.
        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguageCodes, forPreferences: nil).first!
        let matchingName = self.first { name in
            name.language.name == deviceLanguageCode
        }
        return matchingName?.name
    }
}

struct EvolutionTrigger: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// The name of this resource listed in different languages.
    let names: [Name]
    /// A list of pokemon species that result from this evolution trigger.
    let pokemonSpecies: [NamedAPIResource]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case names
        case pokemonSpecies = "pokemon_species"
    }
}

// MARK: SearchByNameOrID conformance
extension EvolutionTrigger: SearchByNameOrID {
    static func from(name: String) async -> EvolutionTrigger? {
        return try? await PokeAPI.getData(for: EvolutionTrigger.self, fromEndpoint: "evolution-trigger/\(name)")
    }
    
    static func from(id: Int) async -> EvolutionTrigger? {
        return await from(name: "\(id)")
    }
}
