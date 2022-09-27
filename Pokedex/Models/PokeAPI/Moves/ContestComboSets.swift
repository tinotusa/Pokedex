//
//  ContestComboSets.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import Foundation

struct ContestComboSets: Codable, Hashable {
    /// A detail of moves this move can be used before or after, granting
    /// additional appeal points in contests.
    let normal: ContestComboDetail
    /// A detail of moves this move can be used before or after, granting
    /// additional appeal points in super contests.
    let `super`: ContestComboDetail
}
