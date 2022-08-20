//
//  AbilityFlavorText.swift
//  Pokedex
//
//  Created by Tino on 20/8/2022.
//

import Foundation

struct AbilityFlavorText: Codable, Hashable {
    /// The localized name for an API resource in a specific language.
    let flavorText: String
    /// The language this text resource is in.
    let language: NamedAPIResource
    /// The version group that uses this flavor text.
    let versionGroup: NamedAPIResource
    
    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
        case versionGroup = "version_group"
    }
}
