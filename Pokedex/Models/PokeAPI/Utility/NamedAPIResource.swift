//
//  NamedAPIResource.swift
//  Pokedex
//
//  Created by Tino on 24/7/2022.
//

import Foundation

struct NamedAPIResource: Codable, Hashable {
    /// The name of the referenced resource.
    let name: String
    /// The URL of the referenced resource.
    let url: URL
}
