//
//  VersionGroupFlavorText.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import Foundation

struct VersionGroupFlavorText: Codable, Hashable {
    /// The localized name for an API resource in a specific language.
    let text: String
    /// The language this name is in.
    let language: NamedAPIResource
    /// The version group which uses this flavor text.
    let versionGroup: NamedAPIResource
    
    enum CodingKeys: String, CodingKey {
        case text
        case language
        case versionGroup = "version_group"
    }
}
