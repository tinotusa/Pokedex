//
//  GrowthRateExperienceLevel.swift
//  Pokedex
//
//  Created by Tino on 22/8/2022.
//

import Foundation

struct GrowthRateExperienceLevel: Codable, Hashable {
    /// The level gained.
    let level: Int
    /// The amount of experience required to reach the referenced level.
    let experience: Int
}
