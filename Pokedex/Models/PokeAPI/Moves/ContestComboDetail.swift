//
//  ContestComboDetail.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import Foundation

struct ContestComboDetail: Codable, Hashable {
    /// A list of moves to use before this move.
    let useBefore: [NamedAPIResource]?
    /// A list of moves to use after this move.
    let userAfter: [NamedAPIResource]?
    
    enum CodingKeys: String, CodingKey {
        case useBefore = "use_before"
        case userAfter = "user_after"
    }
}
