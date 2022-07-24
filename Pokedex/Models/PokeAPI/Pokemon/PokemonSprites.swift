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
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
        case frontFemale = "front_female"
        case frontShinyFemale = "front_shiny_female"
        case backDefault = "back_default"
        case backShiny = "back_shiny"
        case backFemale = "back_female"
        case backShinyFemale = "back_shiny_female"
    }
}
