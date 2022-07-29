//
//  ChainLink.swift
//  Pokedex
//
//  Created by Tino on 29/7/2022.
//

import Foundation

struct ChainLink: Codable, Hashable {
    /// Whether or not this link is for a baby Pokémon. This would only ever be true on the base link.
    let isBaby: Bool
    /// The Pokémon species at this point in the evolution chain.
    let species: NamedAPIResource
    /// All details regarding the specific details of the referenced Pokémon species evolution.
    let evolutionDetails: [EvolutionDetail]?
    /// A List of chain objects.
    let evolvesTo: [ChainLink]
    
    enum CodingKeys: String, CodingKey {
        case isBaby = "is_baby"
        case species
        case evolutionDetails = "evolution_details"
        case evolvesTo = "evolves_to"
    }
}
