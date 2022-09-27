//
//  SearchByNameOrID.swift
//  Pokedex
//
//  Created by Tino on 24/7/2022.
//

import Foundation

protocol SearchByName {
    associatedtype type: Decodable
    /// Looks up the resource by name from PokeAPI.
    /// - parameter: The name of the resource being searched.
    /// - returns: The decoded `type`
    static func from(name: String) async throws -> type
}

protocol SearchByID {
    associatedtype type: Decodable
    /// Looks up the resource by id from PokeAPI.
    /// - parameter: The id of the resource being searched.
    /// - returns: The decoded `type`
    static func from(id: Int) async throws -> type
}

protocol SearchByNameOrID: SearchByName, SearchByID {
    
}
