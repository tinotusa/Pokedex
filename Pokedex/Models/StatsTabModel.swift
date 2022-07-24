//
//  StatsTabModel.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

struct StatsTabModel {
    private let pokemon: Pokemon
    private var pokeAPI: PokeAPI!
    private var hpStat: Stat?
    private var attackStack: Stat?
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
}

extension StatsTabModel {
    var hpStatName: String {
        guard let hpStat else { return "Error1" }
        let availableLanguageCodes = hpStat.names.map { name in
            name.language.name
        }
        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguageCodes).first!
        let matchingName = hpStat.names.first { name in
            return name.language.name == deviceLanguageCode
        }
        guard let matchingName else { return "Error2" }
        return matchingName.name
    }
    
    var hp: Int {
        let hpStat = pokemon.stats.first { stat in
            stat.stat.name == "hp"
        }
        return hpStat?.baseStat ?? 0
    }
    
    var attack: Int {
        let attackStat = pokemon.stats.first { stat in
            stat.stat.name == "attack"
        }
        return attackStat?.baseStat ?? 0
    }
    
    var defense: Int {
        let defenseStat = pokemon.stats.first { stat in
            stat.stat.name == "defense"
        }
        return defenseStat?.baseStat ?? 0
    }
    
    var totalStats: Int {
        pokemon.totalStats
    }
}

extension StatsTabModel {
    mutating func setUp(pokeAPI: PokeAPI) async {
        self.pokeAPI = pokeAPI
        hpStat = await getHPStat()
        attackStack = await  getAttackStat()
    }
}

private extension StatsTabModel {
    func getAttackStat() async -> Stat? {
        let attackStat = pokemon.stats.first { stat in
            stat.stat.name == "attack"
        }
        guard let attackStat else { fatalError("Fatal error in \(#function)\nInvalid pokemon stat") }
        return await Stat.fromName(name: attackStat.stat.name)
    }
    
    func getHPStat() async -> Stat? {
        let hpStat = pokemon.stats.first { stat in
            stat.stat.name == "hp"
        }
        guard let hpStat else { fatalError("Fatal error in \(#function)\nInvalid pokemon stat") }
        return await Stat.fromName(name: hpStat.stat.name)
    }
}
