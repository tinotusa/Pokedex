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

extension ItemFlingEffect: SearchByNameOrID {
    static func from(name: String) async throws -> ItemFlingEffect {
        try await PokeAPI.shared.getData(for: ItemFlingEffect.self, fromEndpoint: "item-fling-effect/\(name)")
    }
    
    static func from(id: Int) async throws -> ItemFlingEffect {
        try await from(name: "\(id)")
    }
}


extension ItemAttribute: SearchByNameOrID {
    static func from(name: String) async throws -> ItemAttribute {
        try await PokeAPI.shared.getData(for: ItemAttribute.self, fromEndpoint: "item-attribute/\(name)")
    }
    
    static func from(id: Int) async throws -> ItemAttribute {
        try await from(name: "\(id)")
    }
}
