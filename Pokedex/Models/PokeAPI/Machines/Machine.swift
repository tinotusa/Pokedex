//
//  Machine.swift
//  Pokedex
//
//  Created by Tino on 24/8/2022.
//

import Foundation

struct Machine: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The TM or HM item that corresponds to this machine.
    let item: NamedAPIResource
    /// The move that is taught by this machine.
    let move: NamedAPIResource
    /// The version group that this machine applies to.
    let versionGroup: NamedAPIResource
}

extension Machine {
    static func from(url: URL) async throws -> Machine {
        try await PokeAPI.shared.getData(for: Machine.self, url: url)
    }
}

extension Machine: Comparable {
    static func < (lhs: Machine, rhs: Machine) -> Bool {
        lhs.id < rhs.id
    }
}
