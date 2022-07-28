//
//  PokemonDetailModel.swift
//  Pokedex
//
//  Created by Tino on 19/7/2022.
//

import SwiftUI

/// The model for the pokemon detail view.
struct PokemonDetailModel {
    let pokemon: Pokemon
    private(set) var pokemonSpecies: PokemonSpecies?
    private(set) var eggGroups = [EggGroup]()
    private(set) var types = [`Type`]()
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
}

// MARK: - Computed properties
extension PokemonDetailModel {
    /// The url for the pokemon's artwork
    var pokemonImageURL: URL? {
        pokemon.officialArtWork
    }
    
    /// The number for the pokemon in the pokedex.
    var pokemonID: Int {
        pokemon.id
    }
}



// MARK: - Functions
extension PokemonDetailModel {
    /// Sets up the model.
    mutating func setUp() async {
        pokemonSpecies = await PokemonSpecies.fromName(name: pokemon.name)
        types = await getTypes()
        await getEggGroups()
    }
    /// Gets the types for this pokemon.
    private mutating func getTypes() async -> [`Type`] {
        var tempTypes = [`Type`]()
        for type in pokemon.types {
            let typeDetails = await `Type`.from(name: type.type.name)
            if let typeDetails {
                tempTypes.append(typeDetails)
            }
        }
        return tempTypes
    }
    
    /// Gets all the egg groups for this pokemon.
    private mutating func getEggGroups() async {
        if pokemonSpecies == nil {
            return
        }
        for eggGroups in pokemonSpecies!.eggGroups {
            guard let group = await EggGroup.from(name: eggGroups.name) else {
                continue
            }
            self.eggGroups.append(group)
        }
    }
}
