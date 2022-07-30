//
//  EvolutionDetail.swift
//  Pokedex
//
//  Created by Tino on 29/7/2022.
//

import Foundation

struct EvolutionDetail: Codable, Hashable {
    /// The item required to cause evolution this into Pokémon species.
    let item: NamedAPIResource?
    /// The type of event that triggers evolution into this Pokémon species.
    let trigger: NamedAPIResource
    /// The id of the gender of the evolving Pokémon species must be in order
    /// to evolve into this Pokémon species.
    let gender: Int?
    /// The item the evolving Pokémon species must be holding during the evolution
    /// trigger event to evolve into this Pokémon species.
    let heldItem: NamedAPIResource?
    /// The move that must be known by the evolving Pokémon species during the
    /// evolution trigger event in order to evolve into this Pokémon species.
    let knownMove: NamedAPIResource?
    /// The evolving Pokémon species must know a move with this type during the
    /// evolution trigger event in order to evolve into this Pokémon species.
    let knownMoveType: NamedAPIResource?
    /// The location the evolution must be triggered at.
    let location: NamedAPIResource?
    /// The minimum required level of the evolving Pokémon species to evolve into
    /// this Pokémon species.
    let minLevel: Int?
    /// The minimum required level of happiness the evolving Pokémon species to evolve
    /// into this Pokémon species.
    let minHappiness: Int?
    /// The minimum required level of beauty the evolving Pokémon species to evolve
    /// into this Pokémon species.
    let minBeauty: Int?
    /// The minimum required level of affection the evolving Pokémon species to evolve
    /// into this Pokémon species.
    let minAffection: Int?
    /// Whether or not it must be raining in the overworld to cause evolution this Pokémon species.
    let needsOverworldRain: Bool
    /// The Pokémon species that must be in the players party in order for the evolving
    /// Pokémon species to evolve into this Pokémon species.
    let partySpecies: NamedAPIResource?
    /// The player must have a Pokémon of this type in their party during the evolution trigger
    /// event in order for the evolving Pokémon species to evolve into this Pokémon species.
    let partyType: NamedAPIResource?
    /// The required relation between the Pokémon's Attack and Defense stats.
    /// 1 means Attack > Defense. 0 means Attack = Defense. -1 means Attack < Defense.
    let relativePhysicalStats: Int?
    /// The required time of day. Day or night.
    let timeOfDay: String
    /// Pokémon species for which this one must be traded.
    let tradeSpecies: NamedAPIResource?
    /// Whether or not the 3DS needs to be turned upside-down as this Pokémon levels up.
    let turnUpsideDown: Bool
    
    enum CodingKeys: String, CodingKey {
        case item
        case trigger
        case gender
        case heldItem = "held_item"
        case knownMove = "known_move"
        case knownMoveType = "known_move_type"
        case location
        case minLevel = "min_level"
        case minHappiness = "min_happiness"
        case minBeauty = "min_beauty"
        case minAffection = "min_affection"
        case needsOverworldRain = "needs_overworld_rain"
        case partySpecies = "party_species"
        case partyType = "party_type"
        case relativePhysicalStats = "relative_physical_stats"
        case timeOfDay = "time_of_day"
        case tradeSpecies = "trade_species"
        case turnUpsideDown = "turn_upside_down"
    }
}

