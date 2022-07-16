//
//  PokemonSpecies.swift
//  Pokedex
//
//  Created by Tino on 15/7/2022.
//

import SwiftUI
/// The pokemon species details.
struct PokemonSpecies: Codable, Hashable, Identifiable {
    let name: String
    let id: Int
    let flavorTextEntries: [FlavorText]
    let genera: [Genus]
    let genderRate: Int
    let eggGroups: [PokemonEggGroup]
}

extension PokemonSpecies {
    var femaleGenderRate: Double {
        (Double(genderRate) / 8.0)
    }
    
    var maleGenderRate: Double {
        (8.0 - Double(genderRate)) / 8.0
    }
    
    var allEggGroups: String {
        let names = eggGroups.compactMap { eggGroup in
            eggGroup.name
        }
        return ListFormatter.localizedString(byJoining: names)
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
    
    var genus: String {
        let codes = genera.compactMap { element in
            element.language.name
        }
        let uniqueLanguageCodes: Set<String> = Set(codes)
        let systemLanguageCode = Bundle.preferredLocalizations(from: Array(uniqueLanguageCodes)).first!
        if let matchingGenera = genera.first(where: { genus in
            genus.language.name == systemLanguageCode
        }) {
            return matchingGenera.genus
        }
        return genera.first!.genus
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case flavorTextEntries = "flavor_text_entries"
        case genera
        case genderRate = "gender_rate"
        case eggGroups = "egg_groups"
    }
}
