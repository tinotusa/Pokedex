//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Tino on 19/7/2022.
//

import SwiftUI


final class PokemonDetailViewModel: ObservableObject {
    @Published var pokemon: Pokemon
    @Published private(set) var pokemonSpecies: PokemonSpecies?
    @Published private(set) var eggGroups = [EggGroup]()
    @Published private(set) var types = [`Type`]()
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    /// Sets up the model.
    @MainActor
    func setUp() async {
        pokemonSpecies = await PokemonSpecies.from(name: pokemon.name)
        types = await getTypes()
        eggGroups = await pokemonSpecies?.eggGroups() ?? []
    }
}

extension PokemonDetailViewModel {
    /// The url for the pokemon's artwork
    var pokemonImageURL: URL? {
        pokemon.officialArtWork
    }
    
    /// The number for the pokemon in the pokedex.
    var pokemonID: Int {
        pokemon.id
    }
    
    /// Gets the types for this pokemon.
    private func getTypes() async -> [`Type`] {
        var tempTypes = [`Type`]()
        for type in pokemon.types {
            let typeDetails = await `Type`.from(name: type.type.name)
            if let typeDetails {
                tempTypes.append(typeDetails)
            }
        }
        return tempTypes
    }
}
