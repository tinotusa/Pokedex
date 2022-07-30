//
//  MoveStatChange.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import Foundation

struct MoveStatChange: Codable, Hashable {
    /// The amount of change.
    let change: Int
    /// The stat being affected.
    let stat:  NamedAPIResource
}
