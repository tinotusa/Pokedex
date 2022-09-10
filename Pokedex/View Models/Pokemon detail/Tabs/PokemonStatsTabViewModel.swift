//
//  PokemonStatsTabViewModel.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

@MainActor
final class PokemonStatsTabViewModel: ObservableObject {
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
    
    @Published private(set) var viewState = ViewState.loading
}

extension PokemonStatsTabViewModel {
    
    
    func loadData(pokemon: Pokemon) async {
        setUp(pokemon: pokemon)
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { @MainActor [self] in
                hpStat = await getStat(for: .hp)
            }
            group.addTask { @MainActor [self] in
                attackStat = await getStat(for: .attack)
            }
            group.addTask { @MainActor [self] in
                defenseStat = await getStat(for: .defense)
            }
            group.addTask { @MainActor [self] in
                specialAttackStat = await getStat(for: .specialAttack)
            }
            group.addTask { @MainActor [self] in
                specialDefenseStat = await getStat(for: .specialDefense)
            }
            group.addTask { @MainActor [self] in
                speedStat = await getStat(for: .speed)
            }
            group.addTask { @MainActor [self] in
                types = await getTypes()
                doubleDamageTo = await doubleDamageTo()
                doubleDamageFrom = await doubleDamageFrom()
            }
            
            await group.waitForAll()
            viewState = .loaded
        }
        
        valuePerStat = [
            .init(name: self.hpStatName, value: hp, colour: "hp"),
            .init(name: self.attackStatName, value: attack, colour: "attack"),
            .init(name: self.defenseStatName, value: defense, colour: "defense"),
            .init(name: self.specialAttackStatName, value: specialAttack, colour: "specialAttack"),
            .init(name: self.specialDefenseStatName, value: specialDefense, colour: "specialDefense"),
            .init(name: self.speedStatName, value: speed, colour: "speed"),
        ]
    }
}

extension PokemonStatsTabViewModel {
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
extension PokemonStatsTabViewModel {
    var hpStatName: String { statName(for: hpStat) }
    var attackStatName: String { statName(for: attackStat) }
    var defenseStatName: String { statName(for: defenseStat) }
    var specialAttackStatName: String { statName(for: specialAttackStat) }
    var specialDefenseStatName: String { statName(for: specialDefenseStat) }
    var speedStatName: String { statName(for: speedStat) }
}

// MARK: - Stat values
extension PokemonStatsTabViewModel {
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
private extension PokemonStatsTabViewModel {
    private func setUp(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
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
        await withTaskGroup(of: `Type`?.self) { group in
            let doubleDamageFrom = types.flatMap { $0.damageRelations.doubleDamageFrom }
            for type in doubleDamageFrom {
                group.addTask {
                    let type = try? await `Type`.from(name: type.name)
                    return type
                }
            }
            
            var results = Set<`Type`>()
            for await type in group {
                if let type {
                    results.insert(type)
                }
            }
            
            return results.sorted()
        }
    }
    
    /// Gets the types that this pokemon's type is strong against.
    /// - returns: An array of `Type` that the pokemon deals double damage to.
    func doubleDamageTo() async -> [`Type`] {
        await withTaskGroup(of: `Type`?.self) { group in
            let doubleDamageTo = types.flatMap { $0.damageRelations.doubleDamageTo }
            
            for type in doubleDamageTo {
                group.addTask {
                    let type = try? await `Type`.from(name: type.name)
                    return type
                }
            }
            var results = Set<`Type`>()
            for await type in group {
                if let type {
                    results.insert(type)
                }
            }
            
            return results.sorted()
        }
    }
}
