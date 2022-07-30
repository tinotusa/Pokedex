//
//  AbilityEffectChange.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import Foundation

struct AbilityEffectChange: Codable, Hashable {
    /// The previous effect of this ability listed in different languages.
    let effectEntries: [Effect]
    /// The version group in which the previous effect of this ability originated.
    let versionGroup: NamedAPIResource
    
    enum CodingKeys: String, CodingKey {
        case effectEntries = "effect_entries"
        case versionGroup = "version_group"
    }
}
