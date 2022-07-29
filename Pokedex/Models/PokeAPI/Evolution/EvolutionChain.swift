//
//  EvolutionChain.swift
//  Pokedex
//
//  Created by Tino on 29/7/2022.
//

import Foundation

struct EvolutionChain: Codable, Hashable {
    /// The identifier for this resource.
    let id: Int
    /// The item that a Pokémon would be holding when mating that would trigger
    /// the egg hatching a baby Pokémon rather than a basic Pokémon.
    let babyTriggerItem: NamedAPIResource?
    /// The base chain link object. Each link contains evolution details for a
    /// Pokémon in the chain. Each link references the next Pokémon in the
    /// natural evolution order.
    let chain: ChainLink
    
    enum CodingKeys: String, CodingKey {
        case id
        case babyTriggerItem = "baby_trigger_item"
        case chain
    }
}

// MARK: - Property wrappers
extension EvolutionChain {
    var name: String {
        chain.species.name
    }
    
    func allEvolutions() -> [ChainLink] {
        var results = [ChainLink]()
        var current = self.chain
        results.append(current)
        while !current.evolvesTo.isEmpty {
            for chain in current.evolvesTo {
                results.append(chain)
            }
            current = current.evolvesTo.first!
        }
        return results
    }
}

// MARK: - SearchByID Conformance
extension EvolutionChain: SearchByID {
    static func from(id: Int) async -> EvolutionChain? {
        return try? await PokeAPI.getData(for: EvolutionChain.self, fromEndpoint: "evolution-chain/\(id)")
    }
}
