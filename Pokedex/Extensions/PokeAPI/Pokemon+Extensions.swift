//
//  Pokemon+Extensions.swift
//  Pokedex
//
//  Created by Tino on 31/8/2022.
//

import Foundation

extension Pokemon {
    var formattedID: String {
        String(format: "#%03d", self.id)
    }
}
