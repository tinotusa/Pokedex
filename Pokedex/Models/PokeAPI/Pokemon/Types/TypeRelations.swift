//
//  TypeRelations.swift
//  Pokedex
//
//  Created by Tino on 24/7/2022.
//

import Foundation

struct TypeRelations: Codable, Hashable {
    /// A list of types this type has no effect on.
    let noDamageTo: [NamedAPIResource]
    /// A list of types this type is not very effect against.
    let halfDamageTo: [NamedAPIResource]
    /// A list of types this type is very effect against.
    let doubleDamageTo: [NamedAPIResource]
    /// A list of types that have no effect on this type.
    let noDamageFrom: [NamedAPIResource]
    /// A list of types that are not very effective against this type.
    let halfDamageFrom: [NamedAPIResource]
    /// A list of types that are very effective against this type.
    let doubleDamageFrom: [NamedAPIResource]
}
