//
//  EvolutionChain+Extensions.swift
//  Pokedex
//
//  Created by Tino on 2/9/2022.
//

import Foundation

extension EvolutionChain {
    static var example: EvolutionChain {
        do {
            return try Bundle.main.loadJSON(ofType: EvolutionChain.self, filename: "evolutionChain", extension: "json")
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
