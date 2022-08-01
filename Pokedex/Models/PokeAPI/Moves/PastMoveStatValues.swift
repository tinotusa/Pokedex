//
//  PastMoveStatValues.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import Foundation

struct PastMoveStatValues: Codable, Hashable {
    /// The percent value of how likely this move is to be successful.
    let accuracy: Int?
    /// The percent value of how likely it is this moves effect will take effect.
    let effectChance: Int?
    /// The base power of this move with a value of 0 if it does not have a base power.
    let power: Int?
    /// Power points. The number of times this move can be used.
    let pp: Int?
    /// The effect of this move listed in different languages.
    let effectEntries: [VerboseEffect]
    /// The elemental type of this move.
    let type: NamedAPIResource?
    /// The version group in which these move stat values were in effect.
    let versionGroup: NamedAPIResource
    
    enum CodingKeys: String, CodingKey {
        case accuracy
        case effectChance = "effect_chance"
        case power
        case pp
        case effectEntries = "effect_entries"
        case type
        case versionGroup = "version_group"
    }
}
