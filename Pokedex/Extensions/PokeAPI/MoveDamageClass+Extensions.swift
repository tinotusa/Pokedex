//
//  MoveDamageClass+Extensions.swift
//  Pokedex
//
//  Created by Tino on 23/9/2022.
//

import Foundation

extension MoveDamageClass {
    static var example: MoveDamageClass {
        do {
            return try Bundle.main.loadJSON(ofType: MoveDamageClass.self, filename: "moveDamageClass", extension: "json")
        } catch {
            fatalError("\(error.localizedDescription)\n\(error)")
        }
    }
}
