//
//  SearchByNameOrID.swift
//  Pokedex
//
//  Created by Tino on 24/7/2022.
//

import Foundation

protocol SearchByName {
    associatedtype type: Decodable
    static func from(name: String) async -> type?
}

protocol SearchByID {
    associatedtype type: Decodable
    static func from(id: Int) async -> type?
}

protocol SearchByNameOrID: SearchByName, SearchByID {
    
}
