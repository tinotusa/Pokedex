//
//  Version.swift
//  Pokedex
//
//  Created by Tino on 14/9/2022.
//

import Foundation

struct Version: Codable, Hashable, Identifiable {
    /// The identifier for this resource.
    let id: Int
    /// The name for this resource.
    let name: String
    /// The name of this resource listed in different languages.
    let names: [Name]
    /// The version group this version belongs to.
    let versionGroup:  NamedAPIResource
}

extension Version: SearchByNameOrID {
    static func from(name: String) async throws -> Version {
        try await PokeAPI.shared.getData(for: Version.self, fromEndpoint: "version/\(name)")
    }
    
    static func from(id: Int) async throws -> Version {
        try await from(name: "\(id)")
    }
}

extension Version: SearchableByURL {
    static func from(url: URL) async throws -> Version {
        try await PokeAPI.shared.getData(for: Version.self, url: url)
    }
}
