//
//  EvolutionDetailRowViewModel.swift
//  Pokedex
//
//  Created by Tino on 2/9/2022.
//

import Foundation

@MainActor
final class EvolutionDetailRowViewModel: ObservableObject {
    @Published var item: Item?
    @Published var evolutionTrigger: EvolutionTrigger?
    @Published var heldItem: Item?
    @Published var knownMove: Move?
    @Published var location: Location?
    @Published var pokemonSpecies: PokemonSpecies?
    @Published var partySpecies: PokemonSpecies?
    @Published var tradeSpecies: PokemonSpecies?
    
    var _settings: Settings?
}

extension EvolutionDetailRowViewModel {
    func setUp(settings: Settings) {
        self._settings = settings
    }
    
    var settings: Settings {
        if let _settings { return _settings }
        fatalError("settings is nil. Call setUp(settings:) first.")
    }
}

// MARK: Functions
extension EvolutionDetailRowViewModel {
    func getItem(named name: String) async {
        item = try? await Item.from(name: name)
    }
    
    func getHeldItem(named name: String) async {
        heldItem = try? await Item.from(name: name)
    }
    
    func getEvolutionTrigger(named name: String) async {
        evolutionTrigger = try? await EvolutionTrigger.from(name: name)
    }
    
    func getKnownMove(named name: String) async {
        knownMove = try? await Move.from(name: name)
    }
    
    func getLocation(named name: String) async {
        location = try? await Location.from(name: name)
    }
    
    func getPartySpecies(named name: String) async {
        pokemonSpecies = try? await PokemonSpecies.from(name: name)
    }
    
    func getTradeSpecies(named name: String) async {
        tradeSpecies = try? await PokemonSpecies.from(name: name)
    }
}

// MARK: Computed properties
extension EvolutionDetailRowViewModel {
    var localizedItemName: String {
        guard let item else { return "Error" }
        return item.names.localizedName(language: settings.language, default: item.name)
    }
    
    var localizedHeldItemName: String {
        guard let heldItem else { return "Error" }
        return heldItem.names.localizedName(language: settings.language, default: heldItem.name)
    }

    var localizedTrigger: String {
        guard let evolutionTrigger else { return "Error" }
        return evolutionTrigger.names.localizedName(language: settings.language, default: evolutionTrigger.name)
    }
    
    var localizedKnownMoveName: String {
        guard let knownMove else { return "Error" }
        return knownMove.names.localizedName(language: settings.language, default: knownMove.name)
    }
    
    var localizedLocationName: String {
        guard let location else { return "Error" }
        return location.names.localizedName(language: settings.language, default: location.name)
    }
    
    var localizedPartySpeciesName: String {
        guard let partySpecies else { return "Error" }
        return partySpecies.names.localizedName(language: settings.language, default: partySpecies.name)
    }
    
    var localizedTradeSpeciesName: String {
        guard let tradeSpecies else { return "Error" }
        return tradeSpecies.names.localizedName(language: settings.language, default: tradeSpecies.name)
    }
}
