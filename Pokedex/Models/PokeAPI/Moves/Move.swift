//
//  Move.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import Foundation

struct Move: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// The percent value of how likely this move is to be successful.
    let accuracy: Int?
    /// The percent value of how likely it is this moves effect will happen.
    let effectChance: Int?
    /// Power points. The number of times this move can be used.
    let pp: Int?
    /// A value between -8 and 8. Sets the order in which moves are executed during battle.
    let priority: Int
    /// The base power of this move with a value of 0 if it does not have a base power.
    /// See [Bulbapedia](http://bulbapedia.bulbagarden.net/wiki/Priority) for greater detail.
    let power: Int?
    /// A detail of normal and super contest combos that require this move.
    let contestCombos: ContestComboSets?
    /// The type of appeal this move gives a Pokémon when used in a contest.
    let contestType: NamedAPIResource?
    /// The effect the move has when used in a contest.
    let contestEffect: APIResource?
    /// The type of damage the move inflicts on the target, e.g. physical.
    let damageClass: NamedAPIResource
    /// The effect of this move listed in different languages.
    let effectEntries: [VerboseEffect]
    /// The list of previous effects this move has had across version groups of the games.
    let effectChanges: [AbilityEffectChange]
    /// List of Pokemon that can learn the move
    let learnedByPokemon: [NamedAPIResource]
    /// The flavor text of this move listed in different languages.
    let flavorTextEntries: [MoveFlavorText]
    /// The generation in which this move was introduced.
    let generation: NamedAPIResource
    /// A list of the machines that teach this move.
    let machines: [MachineVersionDetail]
    /// Metadata about this move
    let meta: MoveMetaData?
    /// The name of this resource listed in different languages.
    let names: [Name]
    /// A list of move resource value changes across version groups of the game.
    let pastValues: [PastMoveStatValues]
    /// A list of stats this moves effects and how much it effects them.
    let statChanges: [MoveStatChange]
    /// The effect the move has when used in a super contest.
    let superContestEffect: APIResource?
    /// The type of target that will receive the effects of the attack.
    let target: NamedAPIResource
    /// The elemental type of this move.
    let type: NamedAPIResource
}

// MARK: - SearchByNameOrID conformance
extension Move: SearchByNameOrID {
    static func from(name: String) async throws -> Move {
        try await PokeAPI.shared.getData(for: Move.self, fromEndpoint: "move/\(name)")
    }
        
    static func from(id: Int) async throws -> Move {
        try await from(name: "\(id)")
    }
}

extension Move: SearchableByURL {
    static func from(url: URL) async throws -> Move {
        try await PokeAPI.shared.getData(for: Move.self, url: url)
    }
}
