//
//  VersionGroup+Extensions.swift
//  Pokedex
//
//  Created by Tino on 23/9/2022.
//

import Foundation

extension VersionGroup: Comparable {
    static func <(lhs: VersionGroup, rhs: VersionGroup) -> Bool {
        lhs.id < rhs.id
    }
}
