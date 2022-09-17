//
//  AbilityDetailViewModel.swift
//  Pokedex
//
//  Created by Tino on 26/8/2022.
//

import SwiftUI
import os

@MainActor
final class AbilityDetailViewModel: ObservableObject {
    @Published var ability: Ability?
    @Published var settings: Settings?
    @Published private(set) var generation: Generation?

    @Published private(set) var viewState = ViewState.loading
    @Published private(set) var abilityInfo = [AbilityInfo: String]()
    @Published private(set) var localizedFlavorTextEntries = [AbilityFlavorText]()
    private let logger = Logger(subsystem: "com.tinotusa.Pokedex", category: "AbilityDetailViewModel")
}

extension AbilityDetailViewModel {
    private func setUp(ability: Ability, settings: Settings) {
        self.ability = ability
        self.settings = settings
    }
    
    func loadData(ability: Ability, settings: Settings) async {
        setUp(ability: ability, settings: settings)
        do {
            generation = try await Generation.from(name: ability.generation.name)
            getLocalizedFlavorTextEntries()
            getAbilityInfo()
            viewState = .loaded
            logger.debug("Successfully loaded data for ability \(ability.id)")
        } catch {
            logger.error("Error for Ability: \(ability.id). \(error.localizedDescription)")
            viewState = .error(error)
        }
    }
    
    enum AbilityInfo: String, CaseIterable, Identifiable {
        case isMainSeries = "main series"
        case generation
        case effectChanges = "effect changes"
        case flavorTextEntries = "flavour text entries"
        case pokemon
        
        var id: Self { self }
        
        var title: LocalizedStringKey {
            LocalizedStringKey(self.rawValue.localizedCapitalized)
        }
    }
    
    func getAbilityInfo() {
        guard let ability else { return }
        abilityInfo[.isMainSeries] = ability.isMainSeries ? "Yes" : "No"
        abilityInfo[.generation] = ability.generation.name
        abilityInfo[.effectChanges] = "\(ability.effectChanges.count) changes"
        abilityInfo[.flavorTextEntries] = "\(localizedFlavorTextEntries.count) entries"
        abilityInfo[.pokemon] = "\(ability.pokemon.count) pokemon"
    }
    
    func getLocalizedFlavorTextEntries() {
        guard let ability else { return }
        
        var entries: [AbilityFlavorText]?
        if let language = settings?.language {
            entries = ability.flavorTextEntries.filter { $0.language.name == language.name }
        }
        
        let availableLanguageCodes = ability.flavorTextEntries.map { $0.language.name }
        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguageCodes, forPreferences: nil).first!
        
        // device language fallback
        if entries == nil {
            entries = ability.flavorTextEntries.filter { $0.language.name == deviceLanguageCode }
        }
        
        // english fallback
        if entries == nil {
            entries = ability.flavorTextEntries.filter{ $0.language.name == "en" }
        }
        
        if let entries {
            localizedFlavorTextEntries = entries
            logger.debug("Added \(entries.count) localized entries for Ability: \(ability.id)")
            return
        }
        logger.debug("No localized entries for Ability: \(ability.id)")
    }
}

// MARK: - Computed properties
extension AbilityDetailViewModel {
    var localizedAbilityName: String {
        guard let ability else { return "Error" }
        guard let settings else { return "Error" }
        return ability.names.localizedName(language: settings.language, default: ability.name)
    }

    var shortFlavorText: String {
        guard let ability else { return "Error" }
        guard let settings else { return "Error" }
        return ability.effectEntries.localizedEffectEntry(shortEffect: true, language: settings.language, default: "Error")
    }
    
    var flavorText: String {
        guard let ability else { return "Error" }
        guard let settings else { return "Error" }
        return ability.effectEntries.localizedEffectEntry(language: settings.language, default: "Error")
    }
    
    var effectChanges: [(versionGroupName: String, effectChange: String)] {
        guard let ability else { return [] }
        guard let settings else { return [] }
        
        var changes = [(String, String)]()
        for effect in ability.effectChanges {
            let effectChange = effect.effectEntries.localizedEffectName(language: settings.language, default: "Error")
            changes.append((effect.versionGroup.name, effectChange))
        }
        return changes
    }
}
