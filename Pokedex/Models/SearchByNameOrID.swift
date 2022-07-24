//
//  SearchByNameOrID.swift
//  Pokedex
//
//  Created by Tino on 24/7/2022.
//

import Foundation

protocol SearchByNameOrID {
    associatedtype type: Decodable
    static func fromName(name: String) async -> type?
    static func fromID(id: Int) async -> type?
}
