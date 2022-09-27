//
//  PokemonInfoTab.swift
//  Pokedex
//
//  Created by Tino on 9/8/2022.
//

import Foundation

enum PokemonInfoTab: String, CaseIterable, Identifiable {
    case about
    case stats
    case evolutions
    case moves
    
    var id: Self { self }
}
