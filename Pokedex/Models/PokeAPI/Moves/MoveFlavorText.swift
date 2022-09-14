//
//  MoveFlavorText.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import Foundation

struct MoveFlavorText: Codable, Hashable {
    /// The localized flavor text for an api resource in a specific language.
    let flavorText: String
    /// The language this name is in.
    let language: NamedAPIResource
    /// The version group that uses this flavor text.
    let versionGroup: NamedAPIResource
}
