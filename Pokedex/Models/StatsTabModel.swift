//
//  StatsTabModel.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

struct StatsTabModel {
    private let pokemon: Pokemon
    private(set) var pokeAPI: PokeAPI!
    private(set) var hpStat: Stat?
    private(set) var attackStat: Stat?
    private(set) var specialAttackStat: Stat?
    private(set) var doubleDamageTo = [`Type`]()
    private(set) var doubleDamageFrom = [`Type`]()
    private(set) var types = [`Type`]()
    
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
    
    var specialAttack: Int {
        let specialAttack = pokemon.stats.first { stat in
            stat.stat.name == "special-attack"
        }
        return specialAttack?.baseStat ?? 0
    }
    
    var specialDefense: Int {
        let specialDefense = pokemon.stats.first { stat in
            stat.stat.name == "special-defense"
        }
        return specialDefense?.baseStat ?? 0
    }
    
    var speed: Int {
        let speed = pokemon.stats.first { stat in
            stat.stat.name == "speed"
        }
        return speed?.baseStat ?? 0
    }
    
    var totalStats: Int {
        pokemon.totalStats
    }
}

extension StatsTabModel {
    mutating func setUp(pokeAPI: PokeAPI) async {
        self.pokeAPI = pokeAPI
        hpStat = await getHPStat()
        attackStat = await getAttackStat()
        specialAttackStat = await getSpecialAttack()
        types = await getTypes()
        doubleDamageTo = await doubleDamageTo()
        doubleDamageFrom = await doubleDamageFrom()
    }
}

private extension StatsTabModel {
    /// Gets the types for this pokemon.
    func getTypes() async -> [`Type`] {
        var results = [`Type`]()
        for type in pokemon.types {
            guard let type = await `Type`.from(name: type.type.name) else {
                continue
            }
            results.append(type)
        }
        return results
    }
    
    func getAttackStat() async -> Stat? {
        let attackStat = pokemon.stats.first { stat in
            stat.stat.name == "attack"
        }
        guard let attackStat else { fatalError("Fatal error in \(#function)\nInvalid pokemon stat") }
        return await Stat.from(name: attackStat.stat.name)
    }
    
    func getHPStat() async -> Stat? {
        let hpStat = pokemon.stats.first { stat in
            stat.stat.name == "hp"
        }
        guard let hpStat else { fatalError("Fatal error in \(#function)\nInvalid pokemon stat") }
        return await Stat.from(name: hpStat.stat.name)
    }
    
    func getSpecialAttack() async -> Stat? {
        let spAttackStat = pokemon.stats.first { stat in
            stat.stat.name  == "special-attack"
        }
        guard let spAttackStat else { fatalError("Fatal error in \(#function)\nInvalid pokemon stat.") }
        return await Stat.from(name: spAttackStat.stat.name)
    }
    
    /// Gets the types that this pokemon's type is weak against.
    func doubleDamageFrom() async -> [`Type`] {
        var results = Set<`Type`>()
        for type in types {
            for type in type.damageRelations.doubleDamageFrom {
                guard let type = await `Type`.from(name: type.name) else { continue }
                results.insert(type)
            }
        }
        return Array(results)
    }
    
    /// Gets the types that this pokemon's type is strong against.
    func doubleDamageTo() async -> [`Type`] {
        var results = Set<`Type`>()
        for type in types {
            for type in type.damageRelations.doubleDamageTo {
                guard let type = await `Type`.from(name: type.name) else { continue }
                results.insert(type)
            }
        }
        return Array(results)
    }
}
