//
//  Pokemon+Extensions.swift
//  Pokedex
//
//  Created by Tino on 31/8/2022.
//

import SwiftUI

// MARK: - Helpers
extension Pokemon {
    var formattedID: String {
        String(format: "#%03d", self.id)
    }
    /// Gets the type names for this pokemon's type.
    /// - returns: an array of strings that contains all of the pokemon's type names.
    func getTypes() -> [String] {
        types.map { type in
            type.type.name
        }
    }
    /// The first types color from xcassets.
    var primaryTypeColour: Color {
        Color(types.first!.type.name)
    }
    /// The sum of all the pokemons stats.
    var totalStats: Int {
        let statValues = stats.map { stat in
            stat.baseStat
        }
        return statValues.reduce(0, +)
    }
    
    /// The official artwork url for this pokemon's image.
    var officialArtWork: URL? {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
    }
    
    var iconURL: URL? {
        let idPath = self.species.url.lastPathComponent
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-viii/icons/\(idPath).png")
    }
    
    /// An example pokemon for xcode previews.
    static var example: Pokemon {
        do {
            return try Bundle.main.loadJSON(ofType: Pokemon.self, filename: "pokemon", extension: "json")
        } catch {
            fatalError("Error in \(#function).\n\(error)")
        }
    }
}
