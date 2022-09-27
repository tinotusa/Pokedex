//
//  MoveDetailViewModel.swift
//  Pokedex
//
//  Created by Tino on 24/8/2022.
//

import SwiftUI
import os

final class MoveDetailViewModel: ObservableObject {
    @Published private(set) var move: Move?
    @Published private(set) var settings: Settings?
    
    @Published private(set) var moveDamageClass: MoveDamageClass?
    @Published private(set) var generation: Generation?
    @Published private(set) var machineItems = [Item]()
    @Published private(set) var moveTarget: MoveTarget?
    @Published private(set) var filteredMoveFlavorTextEntries = [MoveFlavorText]()
    @Published private(set) var localizedEffectChanges = [AbilityEffectChange]()
    // Meta data
    @Published private(set) var moveAilment: MoveAilment?
    @Published private(set) var moveCategory: MoveCategory?
    
    @Published var viewState = ViewState.loading
    
    let unavailableField = "N/A"
    @Published private(set) var moveInfo = [MoveInfoKey: String]()
    @Published private(set) var moveMetaInfo = [MoveMetaInfoKey: String]()
    
    private var logger = Logger(subsystem: "com.tinotusa.Pokedex", category: "MoveDetailViewModel")
}

extension MoveDetailViewModel {
    enum MoveInfoKey: String, CaseIterable, Identifiable{
        case type = "type"
        case target = "target"
        case accuracy = "accuracy"
        case effectChance = "effect chance"
        case powerPoints = "power points"
        case priority = "priority"
        case power = "power"
        case damageClass = "damage class"
        case moveFlavourTextEntries = "flavour text entries"
        case learnedBy = "learned by"
        case generation = "generation"
        case machines = "machines"
        case effectChanges = "effect changes"
        
        var id: Self { self }
        
        var title: LocalizedStringKey {
            "\(self.rawValue.localizedCapitalized)"
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
}

// MARK: - Functions
extension MoveDetailViewModel {
    @MainActor
    func loadData(move: Move, settings: Settings) async {
        logger.debug("Starting to load data for move: \(move.id).")
        setUp(move: move, settings: settings)
        
        async let moveDamageClass = getData(MoveDamageClass.self, named: move.damageClass.name)
        async let generation = getData(Generation.self, named: move.generation.name)
        async let moveTarget = getData(MoveTarget.self, named: move.target.name)
        
        self.moveDamageClass = await moveDamageClass
        self.generation = await generation
        self.moveTarget = await moveTarget
        
        if let meta = move.meta {
            async let moveAilment = getData(MoveAilment.self, named: meta.ailment.name)
            async let moveCategory = getData(MoveCategory.self, named: meta.category.name)
            
            self.moveAilment = await moveAilment
            self.moveCategory = await moveCategory
        } else {
            logger.debug("No move meta on move id: \(move.id)")
        }
        
        getLocalizedMoveFlavourText()
        getMoveInfo()
        getMoveMetaInfo()
        viewState = .loaded
        logger.debug("Successfully loaded data for move: \(move.id).")
    }
 
    var localizedShortVerboseEffect: String {
        localizedVerboseEffect(short: true)
    }
    
    var localizedVerboseEffect: String {
        localizedVerboseEffect()
    }
}

private extension MoveDetailViewModel {
    func setUp(move: Move, settings: Settings) {
        self.move = move
        self.settings = settings
    }
    
    func getLocalizedEffectChanges() -> [AbilityEffectChange] {
        logger.debug("Starting to get localized effect changes.")
        guard let move else {
            logger.debug("Failed to get localized effect changes. move is nil")
            return []
        }
        var changes = [AbilityEffectChange]()
        for abilityEffectChange in move.effectChanges {
            for effect in abilityEffectChange.effectEntries {
                if let language = settings?.language {
                    if effect.language.name == language.name {
                        logger.debug("Adding ability effect change with settings language \(language.name).")
                        changes.append(abilityEffectChange)
                        break
                    }
                }
                let availableLanguageCodes = abilityEffectChange.effectEntries.map { $0.language.name }
                let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguageCodes, forPreferences: nil).first!
                
                if effect.language.name == deviceLanguageCode {
                    logger.debug("Adding ability effect change with deviceLanguageCode \(deviceLanguageCode).")
                    changes.append(abilityEffectChange)
                    break
                }
                
                if effect.language.name == "en" {
                    logger.debug("Adding ability effect change with english.")
                    changes.append(abilityEffectChange)
                    break
                }
            }
        }
        logger.debug("Succesfully added \(changes.count) effect changes.")
        return changes
    }
    
    func getMoveInfo() {
        logger.debug("Starting to get move info.")
        guard let move else {
            logger.debug("Failed to get move info. move is nil.")
            return
        }

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
        if let pp = move.pp {
            moveInfo[.powerPoints] = String(pp)
        } else {
            moveInfo[.powerPoints] = unavailableField
        }
        moveInfo[.priority] = String(move.priority)
        if let power = move.power {
            moveInfo[.power] = String(power)
        } else {
            moveInfo[.power] = unavailableField
        }
        
        moveInfo[.damageClass] = "\(move.damageClass.name)"
        moveInfo[.moveFlavourTextEntries] = "\(filteredMoveFlavorTextEntries.count) entries"
        moveInfo[.learnedBy] = "\(move.learnedByPokemon.count) pokemon"
        moveInfo[.generation] = "\(move.generation.name)"
        
        switch move.machines.count {
        case 1: moveInfo[.machines] = "\(move.machines.count) machine"
        default: moveInfo[.machines] = "\(move.machines.count) machines"
        }
        
        moveInfo[.effectChanges] = "\(move.effectChanges.count)"
    }
    
    func getMoveMetaInfo() {
        guard let move else { return }
        guard let meta = move.meta else { return }
        moveMetaInfo[.ailment] = localizedMoveAilmentName
        moveMetaInfo[.category] = meta.category.name.localizedCapitalized
        if let minHits = meta.minHits {
            moveMetaInfo[.minHits] = "\(minHits)"
        } else {
            moveMetaInfo[.minHits] = unavailableField
        }
        
        if let maxHits = meta.maxHits {
            moveMetaInfo[.maxHits] = "\(maxHits)"
        } else {
            moveMetaInfo[.maxHits] = unavailableField
        }
        
        if let maxTurns = meta.maxTurns {
            moveMetaInfo[.maxTurns] = "\(maxTurns)"
        } else {
            moveMetaInfo[.maxTurns] = unavailableField
        }
        
        moveMetaInfo[.drain] = "\(meta.drain)"
        moveMetaInfo[.healing] = "\(meta.healing)"
        moveMetaInfo[.critRate] = "\(meta.critRate)"
        moveMetaInfo[.ailmentChance] = meta.ailmentChance.formatted(.percent)
        moveMetaInfo[.flinchChance] = meta.flinchChance.formatted(.percent)
        moveMetaInfo[.statChance] = meta.statChance.formatted(.percent)
    }
    
    func localizedVerboseEffect(short: Bool = false) -> String {
        guard let move else {
            logger.debug("Error getting localized verbose effect. move is nil.")
            return "Error"
        }
        guard let settings else {
            logger.debug("Error getting localized verbose effect. settings is nil.")
            return "Error"
        }
        logger.debug("Successfully got localized verbose effect for move: \(move.id)")
        return move.effectEntries.localizedEffectEntry(
            shortEffect: short,
            language: settings.language,
            default: "Error",
            effectChance: move.effectChance
        )
    }
    
    func getData<T: Codable & SearchByNameOrID>(_ type: T.Type, named name: String) async -> T? {
        logger.debug("Getting data named: \(name).")
        do {
            let item = try await T.from(name: name)
            logger.debug("Successfully got data named: \(name).")
            return item as? T
        } catch {
            logger.error("Failed to get data named: \(name). \(error.localizedDescription)")
        }
        return nil
    }
}

// MARK: - Computed properties
extension MoveDetailViewModel {
    var localizedMoveName: String {
        guard let move else { return "Error" }
        guard let settings else { return "Error" }
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
    
    var localizedFlavorText: String {
        guard let move else { return "Error" }
        guard let settings else { return "Error" }
        return move.flavorTextEntries.localizedMoveFlavorText(language: settings.language, default: "Error")
    }
    
    var localizedMoveAilmentName: String {
        guard let moveAilment else {
            print("Error in \(#function). move ailment is nil.")
            return "Error"
        }
        guard let settings else { return "Error" }
        return moveAilment.names.localizedName(language: settings.language, default: moveAilment.name)
    }
    
    func getLocalizedMoveFlavourText() {
        logger.debug("Getting localized move flavour texts.")
        guard let move else {
            logger.debug("Error move is nil.")
            return
        }
        
        var entries: [MoveFlavorText]? = nil
        if let language = settings?.language {
            entries = move.flavorTextEntries.filter { entry in
                entry.language.name == language.name
            }
        }
        
        let availableLanguageCodes = move.flavorTextEntries.map { entry in
            entry.language.name
        }
        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguageCodes, forPreferences: nil).first!
        
        if entries == nil {
            entries = move.flavorTextEntries.filter { entry in
                entry.language.name == deviceLanguageCode
            }
        }
        
        if entries == nil {
            entries = move.flavorTextEntries.filter { entry in
                entry.language.name == "en"
            }
        }
        if let entries {
            self.filteredMoveFlavorTextEntries = entries
            logger.debug("Successfully got localized move flavor text entries.")
            return
        }
        
        logger.error("Failed to get localied move flavor text entries for move: \(move.id).")
    }
    
}
