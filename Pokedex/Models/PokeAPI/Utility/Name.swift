//
//  Name.swift
//  Pokedex
//
//  Created by Tino on 24/7/2022.
//

import Foundation

struct Name: Codable, Hashable {
    /// The localized name for an API resource in a specific language.
    let name: String
    /// The language this name is in.
    let language: NamedAPIResource
}
