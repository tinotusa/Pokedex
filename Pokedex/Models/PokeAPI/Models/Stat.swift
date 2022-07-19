//
//  Stat.swift
//  Pokedex
//
//  Created by Tino on 18/7/2022.
//

import Foundation

struct StatDetails: Codable, Hashable {
    let name: String
    let url: URL
}

struct Stat: Codable, Hashable {
    let baseStat: Int
    let effort: Int
    let statDetails: StatDetails
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort
        case statDetails = "stat"
    }
}
