//
//  ItemFlingEffect.swift
//  Pokedex
//
//  Created by Tino on 23/8/2022.
//

import Foundation

struct ItemFlingEffect: Codable, Hashable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// The result of this fling effect listed in different languages.
    let effectEntries: [Effect]
    /// A list of items that have this fling effect.
    let items: [NamedAPIResource]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case effectEntries = "effect_entries"
        case items
    }
}
