//
//  Generation+Extensions.swift
//  Pokedex
//
//  Created by Tino on 23/9/2022.
//

import Foundation

// MARK: - Example Generation
extension Generation {
    static var example: Generation {
        do {
            return try Bundle.main.loadJSON(ofType: Generation.self, filename: "generation", extension: "json")
        } catch {
            fatalError("Error in \(#function).\n\(error)")
        }
    }
    
    static var exampleGeneration1: Generation {
        do {
            return try Bundle.main.loadJSON(ofType: Generation.self, filename: "generation1", extension: "json")
        } catch {
            fatalError("Error in \(#function).\n\(error)")
        }
    }
}
