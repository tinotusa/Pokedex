//
//  Ability.swift
//  Pokedex
//
//  Created by Tino on 19/7/2022.
//

import SwiftUI

/// The ability of a pokemon (not to be confused with move).
struct Ability: Codable, Hashable {
    /// The name of the ability
    let name: String
    /// The array of names of the ability in different languages.
    let names: [Name]
}
