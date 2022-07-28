//
//  Description.swift
//  Pokedex
//
//  Created by Tino on 28/7/2022.
//

import Foundation

struct Description: Codable, Hashable {
    /// The localized description for an API resource in a specific language.
    let description: String
    /// The language this name is in.
    let language: NamedAPIResource
}
