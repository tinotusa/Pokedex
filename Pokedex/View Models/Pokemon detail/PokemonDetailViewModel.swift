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
    func setUp() async {
        await model.setUp()
    }
}

extension PokemonDetailViewModel {
    var pokemonImageURL: URL? {
        model.pokemonImageURL
    }
    
    var pokemonID: Int {
        model.pokemonID
    }
}
