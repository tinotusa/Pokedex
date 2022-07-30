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
    let flingPower: Int
    /// The effect of the move Fling when used with this item.
    let flingEffect: NamedAPIResource
    /// A list of attributes this item has.
    let attributes: NamedAPIResource
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
    let babyTriggerFor: APIResource
    /// A list of the machines related to this item.
    let machines: [MachineVersionDetail]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case cost
        case flingPower = "fling_power"
        case flingEffect = "fling_effect"
        case attributes
        case category
        case effectEntries = "effect_entries"
        case flavorTextEntries = "flavor_text_entries"
        case gameIndices = "game_indices"
        case names
        case sprites
        case heldByPokemon = "held_by_pokemon"
        case babyTriggerFor = "baby_trigger_for"
        case machines
    }
}
