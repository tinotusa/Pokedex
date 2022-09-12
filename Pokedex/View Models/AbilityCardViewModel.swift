//
//  AbilityCardViewModel.swift
//  Pokedex
//
//  Created by Tino on 11/9/2022.
//

import Foundation

final class AbilityCardViewModel: ObservableObject {
    private var settings: Settings?
    private var ability: Ability?
    
    @Published private(set) var generation: Generation?
    @Published private(set) var viewState = ViewState.loading
}

private extension AbilityCardViewModel {
    func setUp(ability: Ability, settings: Settings) {
        self.ability = ability
        self.settings = settings
    }
    
    func getGeneration(ability: Ability) async {
        do {
            let generation = try await Generation.from(name: ability.generation.name)
            self.generation = generation
            viewState = .loaded
        } catch {
            #if DEBUG
            print("Error in \(#function). Failed to get Generation.")
            #endif
            viewState = .error(error)
            return
        }
    }
}

// MARK: Functions
extension AbilityCardViewModel {
    func loadData(ability: Ability, settings: Settings) async {
        setUp(ability: ability, settings: settings)
        await getGeneration(ability: ability)
    }
}

// MARK: Computed properties
extension AbilityCardViewModel {
    var localizedAbilityName: String {
        guard let ability else { return "Error" }
        guard let settings else { return "Error" }
        
        return ability.names.localizedName(
            language: settings.language,
            default: ability.name
        )
    }
    
    var localizedGenerationName: String {
        guard let settings else { return "Error" }
        guard let generation else { return "Error" }
        return generation.names.localizedName(
            language: settings.language,
            default: generation.name
        )
    }
    
    var localizedEffectShortEntry: String {
        guard let ability else { return "Error" }
        guard let settings else { return "Error" }
        return ability.effectEntries.localizedEffectEntry(shortEffect: true, language: settings.language, default: "Error")
    }
}
