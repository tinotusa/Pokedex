//
//  Version+Extensions.swift
//  Pokedex
//
//  Created by Tino on 22/9/2022.
//

import Foundation

extension Version {
    static var example: Version {
        do {
            return try Bundle.main.loadJSON(ofType: Version.self, filename: "version", extension: "json")
        } catch {
            fatalError("\(error.localizedDescription)\n\(error)")
        }
    }
}
