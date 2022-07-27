//
//  SearchByNameOrID.swift
//  Pokedex
//
//  Created by Tino on 24/7/2022.
//

import Foundation

protocol SearchByNameOrID {
    associatedtype type: Decodable
    static func from(name: String) async -> type?
    static func from(id: Int) async -> type?
}
