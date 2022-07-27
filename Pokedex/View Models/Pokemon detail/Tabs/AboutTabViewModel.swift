//
//  AboutTabViewModel.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

final class AboutTabViewModel: ObservableObject {
    @Published var model: AboutTabModel
    
    init(pokemon: Pokemon) {
        model = AboutTabModel(pokemon: pokemon)
    }
    
    @MainActor
    func setUp() async {
        await model.setUp()
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
    
    var doubleDamageFrom: [String] {
        model.doubleDamageFrom
    }
    
    var doubleDamageTo: [String] {
        model.doubleDamageTo
    }
}
