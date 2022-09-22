//
//  PokemonSpecies+Extensions.swift
//  Pokedex
//
//  Created by Tino on 11/9/2022.
//

import Foundation

// MARK: Computed properties
extension PokemonSpecies {
    /// The female gender rate chance from 0 to 1 (e.g 0.5 for 50% female).
    var femaleGenderRate: Double {
        Double(genderRate) / 8.0
    }
    
    /// The male gender rate chance from 0 to 1 (e.g 0.25 for 25% male).
    var maleGenderRate: Double {
        1.0 - femaleGenderRate
    }
}

// MARK: Functions
extension PokemonSpecies {
    /// Gets the pokemon species' EggGroups
    /// - returns: An array of `EggGroup`
    func eggGroups() async -> [EggGroup] {
        var results = [EggGroup]()
        for eggGroup in self.eggGroups {
            guard let group = try? await EggGroup.from(name: eggGroup.name) else {
                continue
            }
            results.append(group)
        }
        return results
    }
    
    /// Returns the localized seed type name for this pokemon.
    func seedType(language: Language?) -> String {
        let availableLanguageCodes = genera.map { genera in
            genera.language.name
        }
        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguageCodes, forPreferences: nil).first!
        let genera = genera.first { genera in
            genera.language.name == (language != nil ? language!.name : deviceLanguageCode)
        }
        if let genera {
            return genera.genus
        }
        return "Unknown"
    }
    
    func localizedName(language: Language?) -> String {
        return self.names.localizedName(language: language, default: self.name)
    }
}

extension PokemonSpecies: Comparable {
    static func < (lhs: PokemonSpecies, rhs: PokemonSpecies) -> Bool {
        lhs.id < rhs.id
    }
}
