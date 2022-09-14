//
//  Stat.swift
//  Pokedex
//
//  Created by Tino on 18/7/2022.
//

import Foundation

struct PokemonStat: Codable, Hashable {
    /// The stat the Pokémon has.
    let stat: NamedAPIResource
    /// The effort points (EV) the Pokémon has in the stat.
    let effort: Int
    /// The base value of the stat.
    let baseStat: Int
}
