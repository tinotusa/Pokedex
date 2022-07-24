//
//  PokemonMove.swift
//  Pokedex
//
//  Created by Tino on 24/7/2022.
//

import Foundation

struct PokemonMove: Codable, Hashable {
    /// The move the Pokemon can learn.
    let move: NamedAPIResource
    /// The details of the version in which the Pokemon can learn the move.
    let versionGroupDetails: [PokemonMoveVersion]
    
    enum CodingKeys: String, CodingKey {
        case move
        case versionGroupDetails = "version_group_details"
    }
}

struct PokemonMoveVersion: Codable, Hashable {
    /// The method by which the move is learned.
    let moveLearnMethod: NamedAPIResource
    /// The version group in which the move is learned.
    let versionGroup: NamedAPIResource
    /// The minimum level to learn the move.
    let levelLearnedAt: Int
    
    enum CodingKeys: String, CodingKey {
        case moveLearnMethod = "move_learn_method"
        case versionGroup = "version_group"
        case levelLearnedAt = "level_learned_at"
    }
}
