//
//  Type+Extensions.swift
//  Pokedex
//
//  Created by Tino on 14/9/2022.
//

import Foundation

// MARK: Comparable conformance
extension `Type`: Comparable {
    static func < (lhs: Type, rhs: Type) -> Bool {
        lhs.id < rhs.id
    }
}
