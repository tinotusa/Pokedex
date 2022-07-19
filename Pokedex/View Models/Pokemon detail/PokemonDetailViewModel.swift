//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Tino on 19/7/2022.
//

import SwiftUI


final class PokemonDetailViewModel: ObservableObject {
    @Published private(set) var model: PokemonDetailModel
    
    init(pokemon: Pokemon) {
        model = PokemonDetailModel(pokemon: pokemon)
    }
    
    @MainActor
    func setUp(pokeAPI: PokeAPI) async {
        await model.setUp(pokeAPI: pokeAPI)
    }
}

extension PokemonDetailViewModel {
    var pokemonImageURL: URL? {
        model.pokemonImageURL
    }
    
    var pokemonSeedType: String {
        model.pokemonSeedType
    }
    
    var pokemonName: String {
        model.pokemonName
    }
    
    var eggGroupNames: String {
        model.eggGroupNames
    }
    
    var pokemonTypeColour: Color {
        model.pokemonTypeColour
    }
    
    var pokemonTypes: [PokemonTypeDetails] {
        model.pokemonTypes
    }
    
    var pokemonID: Int {
        model.pokemonID
    }

    var pokemonHeight: Double {
        model.pokemonHeight
    }
    
    var pokemonWeight: Double {
        model.pokemonWeight
    }
    
    var pokemonAbilities: String {
        model.pokemonAbilities
    }
    
    var pokemonMaleGenderPercentage: Double {
        model.pokemonMaleGenderPercentage
    }
    
    var pokemonFemaleGenderPercentage: Double {
        model.pokemonfemaleGenderPercentage
    }
    
    var doubleDamageTo: [String] {
        model.doubleDamageTo
    }
    
    var doubleDamageFrom: [String] {
        model.doubleDamageFrom
    }
}
