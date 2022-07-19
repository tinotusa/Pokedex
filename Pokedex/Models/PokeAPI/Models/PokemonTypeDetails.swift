//
//  PokemonTypeDetails.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

struct APIResourceType: Codable, Hashable {
    let name: String
    let url: URL
    
    init(name: String, url: URL) {
        self.name = name
        self.url = url
    }
}

/// The type of a pokemon
struct PokemonTypeDetails: Identifiable, Codable, Hashable {
    let id = UUID().uuidString
    let slot: Int
    let type: APIResourceType
    
    /// Returns the type colour for the type name.
    var colour: Color {
        Color(type.name)
    }
    
    enum CodingKeys: CodingKey {
        case slot
        case type
    }
}
