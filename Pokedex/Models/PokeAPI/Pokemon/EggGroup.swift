//
//  EggGroup.swift
//  Pokedex
//
//  Created by Tino on 19/7/2022.
//

import Foundation

struct PokemonSpeciesDetails: Codable {
    let name: String
    let url: URL
}

struct EggGroup: Identifiable {
    let id: Int
    let name: String
    let names: [Name]
    let pokemonSpecies: [PokemonSpeciesDetails]
}

extension EggGroup: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case names
        case pokemonSpecies = "pokemon_species"
    }
}

extension EggGroup: SearchByNameOrID {
    static func fromName(name: String) async -> EggGroup? {
        try? await PokeAPI.getData(for: EggGroup.self, fromEndpoint: "egg-group/\(name)")
    }
    
    static func fromID(id: Int) async -> EggGroup? {
        let idString = "\(id)"
        return await Self.fromName(name: idString)
    }
}
