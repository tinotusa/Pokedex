//
//  Array+localizedName.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import SwiftUI

extension Array where Element == Name {
    /// Gets a string from the arrays value that matches the given `language`
    /// or gets a string that matches the devices language.
    ///
    ///     let names = [Name]()
    ///     // Tries to find the name matching the devices lanuage.
    ///     // Returns the default if it couldn't.
    ///     names.localizedName(default: "Error")
    ///
    ///
    /// - parameter language: The language to find in the array of `Name`s.
    /// - parameter default: The default string to use if no `Name` matched the given `language`.
    /// - returns: The localized name or the `default` string.
    func localizedName(language: Language? = nil, default defaultValue: String = "Error") -> String {
//        var availableLanguageCodes = ["en"] // adding something to the front of the array will help keep a safe fallback
        let availableLanguageCodes = self.map { name in
            name.language.name
        }
//        availableLanguageCodes.append(contentsOf: temp)
        // This is assuming PokeAPI always has an available language in the `[Name]` array of a type.
        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguageCodes, forPreferences: nil).first!
        
        let matchingName: Name? = self.first { (name: Name) -> Bool in
            guard let language else {
                return name.language.name == deviceLanguageCode
            }
            return name.language.name == language.name
        }
        if let matchingName {
            return matchingName.name
        }
        return defaultValue
    }
}
