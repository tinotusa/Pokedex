//
//  FlavorText.swift
//  Pokedex
//
//  Created by Tino on 16/7/2022.
//

import SwiftUI

struct FlavorText: Codable, Hashable {
    let flavorText: String
    let language: NamedAPIResource
    let version: NamedAPIResource
}
