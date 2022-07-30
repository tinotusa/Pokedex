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

extension Bundle {
    func getData<T: Decodable>(for type: T.Type, fromFileNamed filename: String) -> T {
        let url = Self.main.url(forResource: filename, withExtension: nil)!
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print("Error in \(#function)\n\(error)")
        }
        fatalError("Couldn't read the file at \(filename) json file")
    }
}

extension ChainLink {
    static var example: ChainLink {
        let evolutionChain = Bundle.main.getData(for: EvolutionChain.self, fromFileNamed: "EvolutionChain_ExampleJSON")
        return evolutionChain.chain
    }
}
