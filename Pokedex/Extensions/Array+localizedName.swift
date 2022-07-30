//
//  Array+localizedName.swift
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
