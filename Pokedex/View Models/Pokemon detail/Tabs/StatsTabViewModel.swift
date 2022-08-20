//
//  StatsTabViewModel.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

@MainActor
final class StatsTabViewModel: ObservableObject {
    @Published private(set) var valuePerStat = [ValuePerStat]()
    @Published private var pokemon: Pokemon?
    
    @Published private(set) var hpStat: Stat?
    @Published private(set) var attackStat: Stat?
    @Published private(set) var defenseStat: Stat?
    @Published private(set) var specialAttackStat: Stat?
    @Published private(set) var specialDefenseStat: Stat?
    @Published private(set) var speedStat: Stat?
    
    @Published private(set) var doubleDamageTo = [`Type`]()
    @Published private(set) var doubleDamageFrom = [`Type`]()
    @Published private(set) var types = [`Type`]()
    
    @Published private(set) var isLoading = false
    
    func setUp(pokemon: Pokemon) async {
        isLoading = true
        defer { isLoading = false }
        self.pokemon = pokemon
        
        hpStat = await getStat(for: .hp)
        attackStat = await getStat(for: .attack)
        defenseStat = await getStat(for: .defense)
        specialAttackStat = await getStat(for: .specialAttack)
        specialDefenseStat = await getStat(for: .specialDefense)
        speedStat = await getStat(for: .speed)
        
        types = await getTypes()
        doubleDamageTo = await doubleDamageTo()
        doubleDamageFrom = await doubleDamageFrom()
        
        valuePerStat = [
            .init(name: hpStatName, value: hp, colour: "hp"),
            .init(name: attackStatName, value: attack, colour: "attack"),
            .init(name: defenseStatName, value: defense, colour: "defense"),
            .init(name: specialAttackStatName, value: specialAttack, colour: "specialAttack"),
            .init(name: specialDefenseStatName, value: specialDefense, colour: "specialDefense"),
            .init(name: speedStatName, value: speed, colour: "speed"),
        ]
    }
}

extension StatsTabViewModel {
    struct ValuePerStat: Identifiable {
        let name: String
        let value: Int
        let colour: String
        let id = UUID().uuidString
    }

    enum StatName: String {
        case hp
        case attack
        case defense
        case specialAttack = "special-attack"
        case specialDefense = "special-defense"
        case speed
    }
}

// MARK: - Localized stat names
extension StatsTabViewModel {
    var hpStatName: String { statName(for: hpStat) }
    var attackStatName: String { statName(for: attackStat) }
    var defenseStatName: String { statName(for: defenseStat) }
    var specialAttackStatName: String { statName(for: specialAttackStat) }
    var specialDefenseStatName: String { statName(for: specialDefenseStat) }
    var speedStatName: String { statName(for: speedStat) }
}

// MARK: - Stat values
extension StatsTabViewModel {
    var hp: Int {
        guard let pokemon else { return -1 }
        let hpStat = pokemon.stats.first { stat in
            stat.stat.name == "hp"
        }
        return hpStat?.baseStat ?? 0
    }
    
    var attack: Int {
        guard let pokemon else { return -1 }
        let attackStat = pokemon.stats.first { stat in
            stat.stat.name == "attack"
        }
        return attackStat?.baseStat ?? 0
    }
    
    var defense: Int {
        guard let pokemon else { return -1 }
        let defenseStat = pokemon.stats.first { stat in
            stat.stat.name == "defense"
        }
        return defenseStat?.baseStat ?? 0
    }
    
    var specialAttack: Int {
        guard let pokemon else { return -1 }
        let specialAttack = pokemon.stats.first { stat in
            stat.stat.name == "special-attack"
        }
        return specialAttack?.baseStat ?? 0
    }
    
    var specialDefense: Int {
        guard let pokemon else { return -1 }
        let specialDefense = pokemon.stats.first { stat in
            stat.stat.name == "special-defense"
        }
        return specialDefense?.baseStat ?? 0
    }
    
    var speed: Int {
        guard let pokemon else { return -1 }
        let speed = pokemon.stats.first { stat in
            stat.stat.name == "speed"
        }
        return speed?.baseStat ?? 0
    }
    
    var totalStats: Int {
        guard let pokemon else { return -1 }
        return pokemon.totalStats
    }
}

// MARK: Private functions
private extension StatsTabViewModel {
    /// Gets the localized name for a given stat.
    /// - parameter stat: The stat to get the name for.
    /// - returns: The localized name for the stat or Error if the `Stat` is nil.
    func statName(for stat: Stat?) -> String {
        guard let stat else { return "Error" }
        return stat.names.localizedName(default: stat.name)
    }
    
    /// Gets the types for this pokemon.
    /// - returns: An array of `Type` that the pokemon is.
    func getTypes() async -> [`Type`] {
        guard let pokemon else { return [] }
        var results = [`Type`]()
        for type in pokemon.types {
            guard let type = try? await `Type`.from(name: type.type.name) else {
                continue
            }
            results.append(type)
        }
        return results
    }
    
    /// Gets the `Stat` for a given name.
    ///
    ///     let hpStat = getStat(named: "hp")
    ///
    /// - parameter name: The name of the stat (e.g hp, defense, attack, etc).
    /// - returns: A `Stat` if the name if found or nil otherwise.
    func getStat(for statName: StatName) async -> Stat? {
        guard let pokemon else { return nil }
        let stat = pokemon.stats.first { stat in
            stat.stat.name == statName.rawValue
        }
        guard let stat else { fatalError("Fatal error in \(#function)\nInvalid pokemon stat name \"\(statName.rawValue)\"") }
        return try? await Stat.from(name: stat.stat.name)
    }
    
    /// Gets the types that this pokemon's type is weak against.
    /// - returns: An array of `Type` that the pokemon takes double damage from.
    func doubleDamageFrom() async -> [`Type`] {
        var results = Set<`Type`>()
        for type in types {
            for type in type.damageRelations.doubleDamageFrom {
                guard let type = try? await `Type`.from(name: type.name) else { continue }
                results.insert(type)
            }
        }
        return Array(results).sorted()
    }
    
    /// Gets the types that this pokemon's type is strong against.
    /// - returns: An array of `Type` that the pokemon deals double damage to.
    func doubleDamageTo() async -> [`Type`] {
        var results = Set<`Type`>()
        for type in types {
            for type in type.damageRelations.doubleDamageTo {
                guard let type = try? await `Type`.from(name: type.name) else { continue }
                results.insert(type)
            }
        }
        return Array(results).sorted()
    }
}
