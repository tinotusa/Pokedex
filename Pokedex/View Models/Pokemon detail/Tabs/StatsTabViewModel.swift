//
//  StatsTabViewModel.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

final class StatsTabViewModel: ObservableObject {
    @Published private var model: StatsTabModel
    
    init(pokemon: Pokemon) {
        model = StatsTabModel(pokemon: pokemon)
    }
    
    @MainActor
    func setUp(pokeAPI: PokeAPI) async {
        await model.setUp(pokeAPI: pokeAPI)
    }
}

extension StatsTabViewModel {
    var hp: Int {
        model.hp
    }
    var attack: Int {
        model.attack
    }
    
    var hpStatName: String {
        model.hpStatName
    }
    
    var defense: Int {
        model.defense
    }
    
    var specialAttack: Int {
        model.specialAttack
    }
    
    var specialDefense: Int {
        model.specialDefense
    }
    
    var speed: Int {
        model.speed
    }
    
    var totalStats: Int {
        model.totalStats
    }
    
    var doubleDamageFrom: [`Type`] {
        model.doubleDamageFrom
    }
    
    var doubleDamageTo: [`Type`] {
        model.doubleDamageTo
    }
}
