//
//  Move+Extensions.swift
//  Pokedex
//
//  Created by Tino on 10/9/2022.
//

import Foundation

extension Move {
    static var example: Move {
        do {
            return try Bundle.main.loadJSON(ofType: Move.self, filename: "move", extension: "json")
        } catch {
            fatalError("Error in \(#function).\n\(error)")
        }
    }
    
    func formattedID(format: String = "%03d") -> String {
        String(format: format, self.id)
    }
}
