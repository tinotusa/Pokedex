//
//  Genus.swift
//  Pokedex
//
//  Created by Tino on 16/7/2022.
//

import Foundation

struct Genus: Codable, Hashable {
    let name: String
    let language: LanguageDetails
    
    enum CodingKeys: String, CodingKey {
        case name = "genus"
        case language
    }
}
