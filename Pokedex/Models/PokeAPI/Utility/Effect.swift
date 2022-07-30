//
//  Effect.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import Foundation

struct Effect: Codable, Hashable {
    /// The localized effect text for an API resource in a specific language.
    let effect: String
    /// The language this effect is in.
    let language: NamedAPIResource
}
