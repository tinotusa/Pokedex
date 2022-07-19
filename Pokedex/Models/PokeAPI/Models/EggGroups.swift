//
//  EggGroups.swift
//  Pokedex
//
//  Created by Tino on 19/7/2022.
//

import Foundation

struct PokemonSpeciesDetails: Codable, Hashable {
    let name: String
    let url: URL
}

struct EggGroups: Hashable, Identifiable {
    let id: Int
    let name: String
    let names: [Name]
    let pokemonSpecies: [PokemonSpeciesDetails]
    
}

extension EggGroups: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case names
        case pokemonSpecies = "pokemon_species"
    }
}
