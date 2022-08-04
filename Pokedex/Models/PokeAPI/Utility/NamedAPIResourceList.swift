//
//  NamedAPIResourceList.swift
//  Pokedex
//
//  Created by Tino on 3/8/2022.
//

import Foundation

struct NamedAPIResourceList: Codable, Hashable {
    /// The total number of resources available from this API.
    let count: Int
    /// The URL for the next page in the list.
    let next: String?
    /// The URL for the previous page in the list.
    let previous: String?
    /// A list of named API resources.
    let results: [NamedAPIResource]
}
