//
//  Pokemon.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

/// A pokemon result from PokeAPI.co
struct Pokemon: Identifiable, Hashable {
    let id: Int
    let name: String
    let baseExperience: Int
    let height: Int
    let weight: Int
    let types: [PokemonTypeDetails]
    let sprites: PokemonSprites
    let abilities: [PokemonAbility]
    let stats: [Stat]
}

// MARK: - Helpers
extension Pokemon {
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
    
    /// The colour for the pokemon's type.
    var typeColour: Color {
        types.first!.colour
    }
    
    /// An example pokemon for xcode previews.
    static var example: Pokemon {
        let examplePokemonURL = Bundle.main.url(forResource: "ExamplePokemonJSON", withExtension: nil)!
        do {
            let data = try Data(contentsOf: examplePokemonURL)
            let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
            return pokemon
        } catch {
            print("Error")
        }
        fatalError("Couldn't read the default pokemon json file")
    }
}

// MARK: - Equatable conformance
extension Pokemon: Equatable {
    static func ==(lhs: Pokemon, rhs: Pokemon) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Codable conformance
extension Pokemon: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case baseExperience = "base_experience"
        case height
        case weight
        case types
        case sprites
        case abilities
        case stats
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        guard id > 0 else {
            throw DecodingError.dataCorruptedError(forKey: .id, in: container, debugDescription: "Invalid pokemon id.")
        }
        
        self.name = try container.decode(String.self, forKey: .name)
        guard !name.isEmpty && name.count < 200 else {
            throw DecodingError.dataCorruptedError(forKey: .name, in: container, debugDescription: "Inavlid pokemon name.")
        }
        
        self.baseExperience = try container.decode(Int.self, forKey: .baseExperience)
        guard baseExperience > 0 else {
            throw DecodingError.dataCorruptedError(forKey: .baseExperience, in: container, debugDescription: "Invalid base experience.")
        }
        
        self.height = try container.decode(Int.self, forKey: .height)
        guard height > 0 else {
            throw DecodingError.dataCorruptedError(forKey: .height, in: container, debugDescription: "Invalid height.")
        }
        
        self.weight = try container.decode(Int.self, forKey: .weight)
        guard weight > 0 else {
            throw DecodingError.dataCorruptedError(forKey: .weight, in: container, debugDescription: "Invalid weight.")
        }
        
        self.types = try container.decode([PokemonTypeDetails].self, forKey: .types)
        guard !types.isEmpty else {
            throw DecodingError.dataCorruptedError(forKey: .types, in: container, debugDescription: "Invalid types array.")
        }
        
        self.sprites = try container.decode(PokemonSprites.self, forKey: .sprites)
        
        self.abilities = try container.decode([PokemonAbility].self, forKey: .abilities)
        guard !abilities.isEmpty else {
            throw DecodingError.dataCorruptedError(forKey: .abilities, in: container, debugDescription: "Invalid abilities array.")
        }
        
        self.stats = try container.decode([Stat].self, forKey: .stats)
        guard !stats.isEmpty else {
            throw DecodingError.dataCorruptedError(forKey: .stats, in: container, debugDescription: "Invalid stats array.")
        }
    }
}

