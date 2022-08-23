//
//  ItemCategory.swift
//  Pokedex
//
//  Created by Tino on 23/8/2022.
//

import Foundation

struct ItemCategory: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// A list of items that are a part of this category.
    let items: [NamedAPIResource]
    /// The name of this item category listed in different languages.
    let names: [Name]
    /// The pocket items in this category would be put in.
    let pocket: NamedAPIResource
}
