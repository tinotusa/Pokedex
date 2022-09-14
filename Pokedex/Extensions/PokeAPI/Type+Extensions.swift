//
//  Type+Extensions.swift
//  Pokedex
//
//  Created by Tino on 14/9/2022.
//

import Foundation

extension `Type` {
    static var example: `Type` {
        do {
            return try Bundle.main.loadJSON(ofType: `Type`.self, filename: "type", extension: "json")
        } catch {
            print("Error in \(#function).\n\(error)")
            fatalError(error.localizedDescription)
        }
    }
}

// MARK: Comparable conformance
extension `Type`: Comparable {
    static func < (lhs: Type, rhs: Type) -> Bool {
        lhs.id < rhs.id
    }
}
