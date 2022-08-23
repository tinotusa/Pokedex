//
//  SearchableByNameOrID+Extensions.swift
//  Pokedex
//
//  Created by Tino on 23/8/2022.
//

import Foundation

extension ItemCategory: SearchByNameOrID {
    static func from(name: String) async throws -> ItemCategory{
        try await PokeAPI.shared.getData(for: ItemCategory.self, fromEndpoint: "item-category/\(name)")
    }
    
    static func from(id: Int) async throws -> ItemCategory {
        try await from(name: "\(id)")
    }
}
