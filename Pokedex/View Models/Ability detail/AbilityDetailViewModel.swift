//
//  AbilityDetailViewModel.swift
//  Pokedex
//
//  Created by Tino on 26/8/2022.
//

import Foundation

@MainActor
final class AbilityDetailViewModel: ObservableObject {
    @Published var ability: Ability!
    @Published var settings: Settings!
    @Published private(set) var generation: Generation?
    
    @Published var showingPokemonView = false
    
    @Published var viewHasApeared = false
    @Published var setUpCalled = false
    @Published private(set) var isLoading = false
}

extension AbilityDetailViewModel {
    func setUp(ability: Ability, settings: Settings) {
        defer { setUpCalled = true }
        self.ability = ability
        self.settings = settings
    }
    
    func loadData() async {
        if !setUpCalled {
            fatalError("Error Called load data without calling set up.")
        }
        isLoading = true
        defer { isLoading = false }
        generation = try? await Generation.from(name: ability.generation.name)
    }
    
    /// This is for previews only
    func setGeneration(generation: Generation) {
        self.generation = generation
    }
}

extension AbilityDetailViewModel {
    var localizedAbilityName: String {
        if !setUpCalled { return "Error" }
        return ability.names.localizedName(language: settings.language, default: ability.name)
    }
    
    var abilityID: String {
        if !setUpCalled { return "Error" }
        return String(format: "#%03d", ability.id)
    }

    var shortFlavorText: String {
        if !setUpCalled { return "Error" }
        return ability.effectEntries.localizedEffectEntry(shortEffect: true, language: settings.language, default: "Error")
    }
    
    var flavorText: String {
        if !setUpCalled { return "Error" }
        return ability.effectEntries.localizedEffectEntry(language: settings.language, default: "Error")
    }
    
    var isMainSeriesAbility: String {
        if !setUpCalled { return "Error" }
        return ability.isMainSeries ? "Yes" : "No"
    }
    
    var localizedGeneration: String {
        if !setUpCalled { return "Error" }
        guard let generation else {
            print("Error in \(#function). generation is nil.")
            return "Error"
        }
        return generation.names.localizedName(language: settings.language, default: "Error")
    }
    
    var effectChanges: [(versionGroupName: String, effectChange: String)] {
        if !setUpCalled { return [] }
        var changes = [(String, String)]()
        for effect in ability.effectChanges {
            let effectChange = effect.effectEntries.localizedEffectName(language: settings.language, default: "Error")
            changes.append((effect.versionGroup.name, effectChange))
        }
        return changes
    }
}
