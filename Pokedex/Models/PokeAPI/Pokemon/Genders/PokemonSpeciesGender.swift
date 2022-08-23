//
//  PokemonSpeciesGender.swift
//  Pokedex
//
//  Created by Tino on 22/8/2022.
//

import Foundation

struct PokemonSpeciesGender: Codable, Hashable {
    /// The chance of this Pokémon being female, in eighths; or -1 for genderless.
    let rate: Int
    /// A Pokémon species that can be the referenced gender
    let pokemonSpecies: NamedAPIResource
    
    enum CodingKeys: String, CodingKey {
        case rate
        case pokemonSpecies = "pokemon_species"
    }
}
