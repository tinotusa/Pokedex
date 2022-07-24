//
//  PokeAPILanguage.swift
//  Pokedex
//
//  Created by Tino on 15/7/2022.
//

import SwiftUI

struct PokeAPILanguage: Codable, Identifiable {
    let id: Int?
    let name: String
    let languageCode: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case languageCode = "iso3166"
    }
}
