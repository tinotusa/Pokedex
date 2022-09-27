//
//  Language.swift
//  Pokedex
//
//  Created by Tino on 6/8/2022.
//

import Foundation

struct Language: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// Whether or not the games are published in this language.
    let official: Bool
    /// The two-letter code of the country where this language is spoken. Note that it is not unique.
    let iso639: String
    /// The two-letter code of the language. Note that it is not unique.
    let iso3166: String
    /// The name of this resource listed in different languages.
    let names: [Name]
}

// MARK: Helpers
extension Language {
    /// The language code based on the available langauge codes.
    private var deviceLanguageCode: String {
        let availableLanguageCodes = names.map { $0.language.name }
        return Bundle.preferredLocalizations(from: availableLanguageCodes, forPreferences: nil).first!
    }
    
    /// The full name of the language in its language
    /// e.g ja-Hrkt == 日本語
    var localizedLanguageName: String {
        // the language's full name
        var language = names.first { name in
            name.language.name == self.name
        }
        // fall back if the official name wasn't found
        if language == nil {
            language = names.first { name in
                name.language.name == deviceLanguageCode
            }
        }
        // if no full name or fall back use the default name
        return language?.name ?? self.name
    }
}

// MARK: - SearchByNameOrID conformance
extension Language: SearchByNameOrID {
    static func from(name: String) async throws -> Language {
        try await PokeAPI.shared.getData(for: Language.self, fromEndpoint: "language/\(name)")
    }
    
    static func from(id: Int) async throws -> Language {
        try await from(name: "\(id)")
    }
}

// MARK: - Comparable conformance
extension Language: Comparable {
    static func <(lhs: Language, rhs: Language) -> Bool  {
        lhs.id < rhs.id
    }
}
