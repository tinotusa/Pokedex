//
//  Stat.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import Foundation

struct Stat: Codable, Identifiable {
    let id: Int
    let name: String
    let gameIndex: Int
    let isBattleOnly: Bool
    let names: [Name]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case gameIndex = "game_index"
        case isBattleOnly = "is_battle_only"
        case names
    }
}

extension Stat: SearchByNameOrID {
    static func fromName(name: String) async -> Stat? {
        try? await PokeAPI.getData(for: Stat.self, fromEndpoint: "stat/\(name)")
    }
    
    static func fromID(id: Int) async -> Stat? {
        return await Self.fromName(name: "\(id)")
    }
}
