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
    func localizedName(language: Language?, default defaultValue: String) -> String {
        let availableLanguageCodes = self.map { name in
            name.language.name
        }

        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguageCodes, forPreferences: nil).first!
        
        func nameMatching(languageCode: String, in array: [Name]) -> Name? {
            return array.first {
                $0.language.name == languageCode
            }
        }
        
        
        var name: Name? = nil
        // requested langauge
        if let language {
            name = nameMatching(languageCode: language.name, in: self)
        }
        
        // device language fall back
        if name == nil {
            name = nameMatching(languageCode: deviceLanguageCode, in: self)
        }
        
        // english fallback
        if name == nil {
            name = nameMatching(languageCode: "en", in: self)
        }
        
        if let name {
            return name.name
        }
        return defaultValue
    }
}

extension Array where Element == VersionGroupFlavorText {
    func localizedFlavorTextEntry(language: Language?, default defaultValue: String) -> String {
        let availableLanguageCodes = self.map { entry in
            entry.language.name
        }
        
        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguageCodes, forPreferences: nil).first!
        let entry = self.first { entry in
            entry.language.name == (language?.name != nil ? language!.name : deviceLanguageCode)
        }
        
        if let entry {
            return entry.text
        }

        return defaultValue
    }
}

extension Array where Element == Effect {
    func localizedEffectName(language: Language?, default defaultValue: String) -> String {
        let availableLanguageCodes = self.map { entry in
            entry.language.name
        }
        
        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguageCodes, forPreferences: nil).first!
        let effect = self.first { entry in
            entry.language.name == (language?.name != nil ? language!.name : deviceLanguageCode)
        }
        
        if let effect {
            return effect.effect
        }

        return defaultValue
    }
}

extension Array where Element == VerboseEffect {
    func localizedEffectEntry(shortEffect: Bool = false, language: Language?, default defaultValue: String, effectChance: Int? = nil) -> String {
        let availableLanguageCodes = self.map { effect in
            effect.language.name
        }
        
        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguageCodes, forPreferences: nil).first!
        // look for the requested language
        // look for the device language as fallback
        // look for english as the final fallback
        var effect: VerboseEffect? = nil
        if let language {
            effect = self.first { effect in
                effect.language.name == language.name
            }
        }
        
        if effect == nil {
            effect = self.first { effect in
                effect.language.name == deviceLanguageCode
            }
        }
        let englishLanguageCode = "en"
        if effect == nil {
            effect = self.first { effect in
                effect.language.name == englishLanguageCode
            }
        }
        guard let effect else {
            return defaultValue
        }
        
        var text = effect.effect // long effect text (default)
        
        if shortEffect {
            text = effect.shortEffect
        }
        
        if let effectChance {
            return text.replacingOccurrences(of: "$effect_chance", with: "\(effectChance)")
        }
        return text
    }
}

extension Array where Element == FlavorText {
    func localizedFlavorText(language: Language?, default defaultValue: String) -> String {
        let availableLanguageCodes = self.map { text in
            text.language.name
        }
        
        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguageCodes, forPreferences: nil).first!
        var flavorText: FlavorText? = nil
        // try to find the requested langauge
        if let language {
            flavorText = self.first { text in
                text.language.name == language.name
            }
        }
        
        // if not found try to get device language
        if flavorText == nil {
            flavorText = self.first { text in
                text.language.name == deviceLanguageCode
            }
        }
        
        // fallback to english if all else fails
        if flavorText == nil {
            flavorText = self.first { text in
                text.language.name == "en"
            }
        }
        
        if let flavorText {
            return flavorText.flavorText.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
        }

        return defaultValue
    }
}

extension Array where Element == MoveFlavorText {
    func localizedMoveFlavorText(language: Language?, default defaultValue: String) -> String {
        let availableLanguageCodes = self.map { effect in
            effect.language.name
        }
        
        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguageCodes, forPreferences: nil).first!
        let flavorText = self.first { text in
            text.language.name == (language?.name != nil ? language!.name : deviceLanguageCode)
        }
        
        if let flavorText {
            return flavorText.flavorText.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
        }

        return defaultValue
    }
}

extension Array where Element == AbilityFlavorText {
    func localizedAbilityFlavorText(language: Language?, default defaultValue: String) -> String {
        let availableLanguageCodes = self.map { abilityFlavorText in
            abilityFlavorText.language.name
        }
        
        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguageCodes, forPreferences: nil).first!
        let flavorText = self.first { abilityFlavorText in
            abilityFlavorText.language.name == (language?.name != nil ? language!.name : deviceLanguageCode)
        }
        
        if let flavorText {
            return flavorText.flavorText
        }

        return defaultValue
    }
}
