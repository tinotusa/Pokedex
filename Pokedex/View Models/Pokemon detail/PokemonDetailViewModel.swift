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
}
