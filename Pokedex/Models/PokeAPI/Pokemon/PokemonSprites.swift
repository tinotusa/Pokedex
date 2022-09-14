//
//  PokemonSprites.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

struct PokemonSprites: Codable, Hashable {
    let frontDefault: URL?
    let frontShiny: URL?
    let frontFemale: URL?
    let frontShinyFemale: URL?
    let backDefault: URL?
    let backShiny: URL?
    let backFemale: URL?
    let backShinyFemale: URL?
}
