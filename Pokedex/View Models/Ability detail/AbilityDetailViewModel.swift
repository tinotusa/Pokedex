//
//  AbilityDetailViewModel.swift
//  Pokedex
//
//  Created by Tino on 26/8/2022.
//

import Foundation

@MainActor
final class AbilityDetailViewModel: ObservableObject {
    @Published var ability: Ability?
    @Published var settings: Settings?
    @Published private(set) var generation: Generation?
    
    @Published var showingPokemonView = false
    @Published var showEffectChangesView = false
    
    @Published private(set) var viewState = ViewState.loading
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
            viewState = .loaded
        } catch {
            #if DEBUG
            print("Error in \(#function).\n\(error)")
            #endif
            viewState = .error(error)
        }
    }
    
    /// This is for previews only
    func setGeneration(generation: Generation) {
        self.generation = generation
    }
}

extension AbilityDetailViewModel {
    var localizedAbilityName: String {
        guard let ability else { return "Error" }
        guard let settings else { return "Error" }
        return ability.names.localizedName(language: settings.language, default: ability.name)
    }
    
    var abilityID: String {
        guard let ability else { return "Error" }
        return String(format: "#%03d", ability.id)
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
    
    var isMainSeriesAbility: String {
        guard let ability else { return "Error" }
        return ability.isMainSeries ? "Yes" : "No"
    }
    
    var localizedGeneration: String {
        guard let generation else {
            print("Error in \(#function). generation is nil.")
            return "Error"
        }
        guard let settings else { return "Error" }
        return generation.names.localizedName(language: settings.language, default: "Error")
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
