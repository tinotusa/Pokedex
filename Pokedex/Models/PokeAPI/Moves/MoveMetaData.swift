//
//  MoveMetaData.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import Foundation

struct MoveMetaData: Codable, Hashable {
    /// The status ailment this move inflicts on its target.
    let ailment: NamedAPIResource
    /// The category of move this move falls under, e.g. damage or ailment.
    let category: NamedAPIResource
    /// The minimum number of times this move hits. Null if it always only hits once.
    let minHits: Int?
    /// The maximum number of times this move hits. Null if it always only hits once.
    let maxHits: Int?
    /// The minimum number of turns this move continues to take effect. Null if it always only lasts one turn.
    let minTurns: Int?
    /// The maximum number of turns this move continues to take effect. Null if it always only lasts one turn.
    let maxTurns: Int?
    /// HP drain (if positive) or Recoil damage (if negative), in percent of damage done.
    let drain: Int
    /// The amount of hp gained by the attacking Pokemon, in percent of it's maximum HP.
    let healing: Int
    /// Critical hit rate bonus.
    let critRate: Int
    /// The likelihood this attack will cause an ailment.
    let ailmentChance: Int
    /// The likelihood this attack will cause the target Pokémon to flinch.
    let flinchChance: Int
    /// The likelihood this attack will cause a stat change in the target Pokémon.
    let statChance: Int
    
    enum CodingKeys: String, CodingKey {
        case ailment
        case category
        case minHits = "min_hits"
        case maxHits = "max_hits"
        case minTurns = "min_turns"
        case maxTurns = "max_turns"
        case drain
        case healing
        case critRate = "crit_rate"
        case ailmentChance = "ailment_chance"
        case flinchChance = "flinch_chance"
        case statChance = "stat_chance"
    }
}
