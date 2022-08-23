//
//  ItemAttribute.swift
//  Pokedex
//
//  Created by Tino on 23/8/2022.
//

import Foundation

struct ItemAttribute: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// A list of items that have this attribute.
    let items: [NamedAPIResource]
    /// The name of this item attribute listed in different languages.
    let names: [Name]
    /// The description of this item attribute listed in different languages.
    let descriptions: [Description]
}
