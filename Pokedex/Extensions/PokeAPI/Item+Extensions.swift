//
//  Item+Extensions.swift
//  Pokedex
//
//  Created by Tino on 11/9/2022.
//

import Foundation

extension Item {
    static var example: Item {
        do {
            return try Bundle.main.loadJSON(ofType: Item.self, filename: "item", extension: "json")
        } catch {
            fatalError("No item.json file.")
        }
    }
}
