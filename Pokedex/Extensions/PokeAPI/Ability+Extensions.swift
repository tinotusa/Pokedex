//
//  Ability+Extensions.swift
//  Pokedex
//
//  Created by Tino on 14/9/2022.
//

import Foundation

// MARK: - Example Ability
extension Ability {
    static var example: Ability {
        do {
            return try Bundle.main.loadJSON(ofType: Ability.self, filename: "ability", extension: "json")
        } catch {
            fatalError("Error in \(#function).\n\(error)")
        }
    }
}

// MARK: - Comparable conformance
extension Ability: Comparable {
    static func < (lhs: Ability, rhs: Ability) -> Bool {
        lhs.id < rhs.id
    }
}
