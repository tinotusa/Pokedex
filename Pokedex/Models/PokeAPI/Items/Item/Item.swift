//
//  Item.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import Foundation

struct Item: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// The price of this item in stores.
    let cost: Int
    /// The power of the move Fling when used with this item.
    let flingPower: Int?
    /// The effect of the move Fling when used with this item.
    let flingEffect: NamedAPIResource?
    /// A list of attributes this item has.
    let attributes: [NamedAPIResource]
    /// The category of items this item falls into.
    let category: NamedAPIResource
    /// The effect of this ability listed in different languages.
    let effectEntries: [VerboseEffect]
    /// The flavor text of this ability listed in different languages.
    let flavorTextEntries: [VersionGroupFlavorText]
    /// A list of game indices relevent to this item by generation.
    let gameIndices: [GenerationGameIndex]
    /// The name of this item listed in different languages.
    let names: [Name]
    /// A set of sprites used to depict this item in the game.
    let sprites: ItemSprites
    /// A list of Pokémon that might be found in the wild holding this item.
    let heldByPokemon: [ItemHolderPokemon]
    /// An evolution chain this item requires to produce a bay during mating.
    let babyTriggerFor: APIResource?
    /// A list of the machines related to this item.
    let machines: [MachineVersionDetail]
}

// MARK: - SearchByNameOrID conformance
extension Item: SearchByNameOrID {
    static func from(name: String) async throws -> Item {
        try await PokeAPI.shared.getData(for: Item.self, fromEndpoint: "item/\(name)")
    }
    
    static func from(id: Int) async throws -> Item {
        try await from(name: "\(id)")
    }
}

// MARK: - Comparable conformance
extension Item: Comparable {
    static func < (lhs: Item, rhs: Item) -> Bool {
        lhs.id < rhs.id
    }
}
