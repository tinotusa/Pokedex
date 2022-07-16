//
//  FlavorText.swift
//  Pokedex
//
//  Created by Tino on 16/7/2022.
//

import SwiftUI

struct FlavorText: Codable, Hashable {
    let flavorText: String
    let language: PokeAPILanguage
    
    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var temp = try container.decode(String.self, forKey: .flavorText)
        temp = temp.replacingOccurrences(of: "\n", with: " ")
        temp = temp.replacingOccurrences(of: "\u{0C}", with: " ")
        self.flavorText = temp
        
        self.language = try container.decode(PokeAPILanguage.self, forKey: .language)
    }
}
