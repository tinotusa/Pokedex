//
//  VerboseEffect.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import Foundation

struct VerboseEffect: Codable, Hashable {
    /// The localized effect text for an API resource in a specific language.
    let effect: String
    /// The localized effect text in brief.
    let shortEffect: String
    /// The language this effect is in.
    let language: NamedAPIResource
    
    enum CodingKeys: String, CodingKey {
        case effect
        case shortEffect = "short_effect"
        case language
    }
}
