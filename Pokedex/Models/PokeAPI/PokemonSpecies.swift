//
//  PokemonSpecies.swift
//  Pokedex
//
//  Created by Tino on 15/7/2022.
//

import SwiftUI

/// The pokemon species details.
struct PokemonSpecies: Codable, Identifiable {
    let name: String
    let id: Int
    let flavorTextEntries: [FlavorText]
    let genera: [Genus]
    let genderRate: Int
    let eggGroups: [EggGroupsDetails]
    let names: [Name]
}

extension PokemonSpecies {
    /// Returns the localized seed type name for this pokemon.
    var seedType: String {
        let availableLanguageCodes = genera.map { genera in
            genera.language.name
        }
        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguageCodes).first!
        let genera = genera.first { genera in
            genera.language.name == deviceLanguageCode
        }
        if let genera {
            return genera.genus
        }
        return "Unknown"
    }
    
    var femaleGenderRate: Double {
        (Double(genderRate) / 8.0)
    }
    
    var maleGenderRate: Double {
        (8.0 - Double(genderRate)) / 8.0
    }
    
    var aboutText: String {
        let availableLanguageCodes = flavorTextEntries.compactMap { flavorText in
            flavorText.language.name
        }
        let uniqueLanguageCodes = Set(availableLanguageCodes)
        let systemLanguageCode = Bundle.preferredLocalizations(from: Array(uniqueLanguageCodes)).first!
        if let matchingFlavorText = flavorTextEntries.first(where: {  flavorText in
            flavorText.language.name == systemLanguageCode
        }) {
            return matchingFlavorText.flavorText
        }
        return flavorTextEntries.first!.flavorText
    }

    enum CodingKeys: String, CodingKey {
        case name
        case id
        case flavorTextEntries = "flavor_text_entries"
        case genera
        case genderRate = "gender_rate"
        case eggGroups = "egg_groups"
        case names
    }
    
    static func fromName(name: String) async -> PokemonSpecies? {
        return try? await PokeAPI.getData(for: PokemonSpecies.self, fromEndpoint: "pokemon-species/\(name)")
    }
}
