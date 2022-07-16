//
//  PokeAPIName.swift
//  Pokedex
//
//  Created by Tino on 16/7/2022.
//

import Foundation

struct PokeAPIName: Codable, Hashable {
    let name: String
    let language: PokeAPILanguage
}
