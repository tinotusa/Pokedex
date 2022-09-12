//
//  MoveDetailViewModel.swift
//  Pokedex
//
//  Created by Tino on 24/8/2022.
//

import Foundation

final class MoveDetailViewModel: ObservableObject {
    @Published private(set) var move: Move?
    @Published private(set) var settings: Settings?
    @Published private(set) var moveDamageClass: MoveDamageClass?
    @Published private(set) var generation: Generation?
    @Published private(set) var machineItems = [Item]()
    @Published private(set) var moveTarget: MoveTarget?
    
    // Meta data
    @Published private(set) var moveAilment: MoveAilment?
    @Published private(set) var moveCategory: MoveCategory?
    // other
    @Published var showMachinesList = false
    @Published var showPokemonList = false
    @Published var viewState = ViewState.loading
    
    let unavailableField = "N/A"
    @Published private(set) var moveInfo = [MoveInfoKey: String]()
    @Published private(set) var moveMetaInfo = [MoveMetaInfoKey: String]()
}

private extension MoveDetailViewModel {
    private func setUp(move: Move, settings: Settings) {
        self.move = move
        self.settings = settings
    }
    
    private func getInt(_ value: Int?, formatStyle: FloatingPointFormatStyle<Double>.Percent? = nil) -> String {
        guard let value else {
            return "N/A"
        }
        if let formatStyle {
            return formatStyle.format(Double(value) / 100.0)
        }
        return "\(value)"
    }
}

// MARK: - Functions
extension MoveDetailViewModel {
    @MainActor
    func loadData(move: Move, settings: Settings) async {
        setUp(move: move, settings: settings)

        await withTaskGroup(of: Void.self) { [self] group in
            group.addTask { @MainActor [self] in
                moveDamageClass = try? await MoveDamageClass.from(name: move.damageClass.name)
            }
            
            group.addTask { @MainActor [self] in
                generation = try? await Generation.from(name: move.generation.name)
            }
            
            group.addTask { @MainActor [self] in
                moveAilment = try? await MoveAilment.from(name: move.meta.ailment.name)
            }
            
            group.addTask { @MainActor [self] in
                moveCategory = try? await MoveCategory.from(name: move.meta.category.name)
            }
            
            group.addTask { @MainActor [self] in
                moveTarget = try? await MoveTarget.from(name: move.target.name)
            }
            
            await group.waitForAll()
            getMoveInfo()
            getMoveMetaInfo()
            viewState = .loaded
        }
    }
    
    enum MoveInfoKey: String, CaseIterable, Identifiable{
        case type = "type"
        case target = "target"
        case accuracy = "accuracy"
        case effectChance = "effect chance"
        case powerPoints = "power points"
        case priority = "priority"
        case power = "power"
        case damageClass = "damage class"
        case effect = "effect"
        case learnedBy = "learned by"
        case generation = "generation"
        case machines = "machines"
        
        var id: Self { self }
    }
    
    private func getMoveInfo() {
        guard let move else { return }

        moveInfo[.type] = move.type.name
        moveInfo[.target] = localizedTargetName
        
        if let accuracy = move.accuracy {
            moveInfo[.accuracy] = accuracy.formatted(.percent)
        } else {
            moveInfo[.accuracy] = unavailableField
        }
        
        if let effectChance = move.effectChance {
            moveInfo[.effectChance] = String(effectChance)
        } else {
            moveInfo[.effectChance] = unavailableField
        }
        
        moveInfo[.powerPoints] = String(move.pp)
        moveInfo[.priority] = String(move.priority)
        if let power = move.power {
            moveInfo[.power] = String(power)
        } else {
            moveInfo[.power] = unavailableField
        }
        
        moveInfo[.damageClass] = "\(move.damageClass.name)"
        moveInfo[.effect] = localizedShortVerboseEffect
        moveInfo[.learnedBy] = "\(move.learnedByPokemon.count) pokemon"
        moveInfo[.generation] = "\(move.generation.name)"
        
        switch move.machines.count {
        case 1: moveInfo[.machines] = "\(move.machines.count) machine"
        default: moveInfo[.machines] = "\(move.machines.count) machines"
        }
    }
    
    enum MoveMetaInfoKey: String, CaseIterable, Identifiable {
        case ailment = "ailment"
        case category = "category"
        case minHits = "min hits"
        case maxHits = "max hits"
        case maxTurns = "max turns"
        case drain = "drain"
        case healing = "healing"
        case critRate = "crit rate"
        case ailmentChance = "ailment chance"
        case flinchChance = "flinch chance"
        case statChance = "stat chance"
        
        var id: Self { self }
    }
    
    private func getMoveMetaInfo() {
        guard let move else { return }
        moveMetaInfo[.ailment] = move.meta.ailment.name
        moveMetaInfo[.category] = move.meta.category.name.localizedCapitalized
        if let minHits = move.meta.minHits {
            moveMetaInfo[.minHits] = "\(minHits)"
        } else {
            moveMetaInfo[.minHits] = unavailableField
        }
        
        if let maxHits = move.meta.maxHits {
            moveMetaInfo[.maxHits] = "\(maxHits)"
        } else {
            moveMetaInfo[.maxHits] = unavailableField
        }
        
        if let maxTurns = move.meta.maxTurns {
            moveMetaInfo[.maxTurns] = "\(maxTurns)"
        } else {
            moveMetaInfo[.maxTurns] = unavailableField
        }
        
        moveMetaInfo[.drain] = "\(move.meta.drain)"
        moveMetaInfo[.healing] = "\(move.meta.healing)"
        moveMetaInfo[.critRate] = "\(move.meta.critRate)"
        moveMetaInfo[.ailmentChance] = move.meta.ailmentChance.formatted(.percent)
        moveMetaInfo[.flinchChance] = move.meta.flinchChance.formatted(.percent)
        moveMetaInfo[.statChance] = move.meta.statChance.formatted(.percent)
    }
    
    func showLearnedByPokemonView() {
        showPokemonList = true
    }
    
    func showMachinesListView() {
        showMachinesList = true
    }
}

// MARK: - Computed properties
extension MoveDetailViewModel {
    var localizedMoveName: String {
        guard let move else { return "Error"}
        guard let settings else { return "Error"}
        return move.names
            .localizedName(
                language: settings.language,
                default: move.name
            )
    }
    
    var localizedTargetName: String {
        guard let settings else { return "Error" }
        guard let moveTarget else {
            print("Error in \(#function). moveTarget is nil.")
            return "Error"
        }
        return moveTarget.names.localizedName(language: settings.language, default: moveTarget.name)
    }
    
    var moveID: Int {
        guard let move else { return -1 }
        return move.id
    }
    
    var machinesCount: String {
        guard let move else { return "Error" }
        let count = move.machines.count
        if count == 0 {
            return "N/A"
        }
        return "\(count)"
    }
    
    var accuracy: String {
        guard let move else { return "Error" }
        if let accuracy = move.accuracy {
            return "\(accuracy.formatted(.percent))"
        }
        return "N/A"
    }
    
    var effectChance: String {
        guard let move else { return "Error" }
        if let effect = move.effectChance {
            return "\(effect.formatted(.percent))"
        }
        return "N/A"
    }
    
    var power: String {
        guard let move else { return "Error" }
        if let power = move.power {
            return "\(power)"
        }
        return "N/A"
    }
    
    var localizedMoveDamageClassName: String {
        guard let moveDamageClass else {
            print("Error in \(#function). moveDamageClass is nil.")
            return "Error"
        }
        guard let settings else { return "Error" }
        
        return moveDamageClass
            .names
            .localizedName(
                language: settings.language,
                default: moveDamageClass.name
            )
            .localizedCapitalized
    }
    
    var localizedShortVerboseEffect: String {
        guard let move else { return "Error" }
        guard let settings else { return "Error" }
        return move.effectEntries.localizedEffectEntry(
            shortEffect: true,
            language: settings.language,
            default: "Error",
            effectChance: move.effectChance
        )
    }
    
    var localizedFlavorText: String {
        guard let move else { return "Error" }
        guard let settings else { return "Error" }
        return move.flavorTextEntries.localizedMoveFlavorText(language: settings.language, default: "Error")
    }
    
    var localizedGenerationName: String {
        guard let generation else {
            print("Error in \(#function). generation is nil.")
            return "Error"
        }
        guard let settings else { return "Error" }
        return generation.names.localizedName(language: settings.language, default: "Error")
    }
    
    var moveCanBeTaughtByMachines: Bool {
        guard let move else { return false }
        return !move.machines.isEmpty
    }
}

// MARK: Move metadata computed properties
extension MoveDetailViewModel {
    var localizedMoveAilmentName: String {
        guard let moveAilment else {
            print("Error in \(#function). move ailment is nil.")
            return "Error"
        }
        guard let settings else { return "Error" }
        return moveAilment.names.localizedName(language: settings.language, default: moveAilment.name)
    }
    
    var moveCategoryName: String {
        guard let moveCategory else {
            print("Error in \(#function). move category is nil.")
            return "Error"
        }
        return moveCategory.name.localizedCapitalized
    }
    
    var minHits: String {
        guard let move else { return "Error" }
        return getInt(move.meta.minHits)
    }
    
    var maxHits: String {
        guard let move else { return "Error" }
        return getInt(move.meta.maxHits)
    }
    
    var maxTurns: String {
        guard let move else { return "Error" }
        return getInt(move.meta.maxTurns)
    }
    
    var drain: String {
        guard let move else { return "Error" }
        return getInt(move.meta.drain)
    }
    
    var healing: String {
        guard let move else { return "Error" }
        return getInt(move.meta.healing)
    }
    
    var critRate: String {
        guard let move else { return "Error" }
        return getInt(move.meta.critRate)
    }
    
    var ailmentChance: String {
        guard let move else { return "Error" }
        return getInt(move.meta.ailmentChance, formatStyle: .percent)
    }
    
    var flinchChance: String {
        guard let move else { return "Error" }
        return getInt(move.meta.flinchChance, formatStyle: .percent)
    }
    
    var statChance: String {
        guard let move else { return "Error" }
        return getInt(move.meta.statChance, formatStyle: .percent)
    }
}
