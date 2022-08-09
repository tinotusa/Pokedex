//
//  Array+localizedName.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import SwiftUI

extension Array where Element == Name {
    var localizedName: String? {
        @AppStorage("appSettings") var appSettings = Data()
        let settings = SettingsManager.load(from: appSettings)
//        var availableLanguageCodes = ["en"] // adding something to the front of the array will help keep a safe fallback
        let availableLanguageCodes = self.map { name in
            name.language.name
        }
//        availableLanguageCodes.append(contentsOf: temp)
        // This is assuming PokeAPI always has an available language in the `[Name]` array of a type.
        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguageCodes, forPreferences: nil).first!
        
        let matchingName: Name? = self.first { (name: Name) -> Bool in
            guard let settings else {
                return name.language.name == deviceLanguageCode
            }
            guard let language = settings.language else {
                return name.language.name == deviceLanguageCode
            }
            return name.language.name == language.name
        }
        return matchingName?.name
    }
}
