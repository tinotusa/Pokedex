//
//  MachineVersionDetail.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import Foundation

struct MachineVersionDetail: Codable, Hashable {
    /// The machine that teaches a move from an item.
    let machine: APIResource
    /// The version group of this specific machine.
    let versionGroup: NamedAPIResource
    
    enum CodingKeys: String, CodingKey {
        case machine
        case versionGroup = "version_group"
    }
}
