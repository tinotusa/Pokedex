//
//  StatsTabViewModel.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

struct ValuePerStat: Identifiable {
    let name: String
    let value: Int
    let colour: String
    let id = UUID().uuidString
}


final class StatsTabViewModel: ObservableObject {
    @Published private var model: StatsTabModel
    @Published private(set) var valuePerStat = [ValuePerStat]()

    init(pokemon: Pokemon) {
        model = StatsTabModel(pokemon: pokemon)
    }
    
    @MainActor
    func setUp() async {
        await model.setUp()
        valuePerStat = [
            .init(name: "HP", value: model.hp, colour: "hp"),
            .init(name: "Attack", value: model.attack, colour: "attack"),
            .init(name: "Defense", value: model.defense, colour: "defense"),
            .init(name: "Sp. Attack", value: model.specialAttack, colour: "specialAttack"),
            .init(name: "Sp. Defense", value: model.specialDefense, colour: "specialDefense"),
            .init(name: "Speed", value: model.speed, colour: "speed"),
        ]
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
        model.doubleDamageFrom.sorted()
    }
    
    var doubleDamageTo: [`Type`] {
        model.doubleDamageTo.sorted()
    }
}
