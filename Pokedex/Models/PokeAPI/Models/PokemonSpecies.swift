//
//  PokemonSpecies.swift
//  Pokedex
//
//  Created by Tino on 15/7/2022.
//

import SwiftUI

struct LanguageDetails: Codable, Hashable {
    let languageCode: String
    let url: URL
    
    enum CodingKeys: String, CodingKey {
        case languageCode = "name"
        case url
    }
}

struct Name: Codable, Hashable {
    let language: LanguageDetails
    let name: String
}

/// The pokemon species details.
struct PokemonSpecies: Codable, Hashable, Identifiable {
    let name: String
    let id: Int
    let flavorTextEntries: [FlavorText]
    let genera: [Genus]
    let genderRate: Int
    let eggGroups: [EggGroupsDetails]
    let names: [Name]
}

extension PokemonSpecies {
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
}
