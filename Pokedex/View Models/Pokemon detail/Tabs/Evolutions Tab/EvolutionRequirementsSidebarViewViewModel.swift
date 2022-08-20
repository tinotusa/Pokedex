//
//  EvolutionRequirementsSidebarViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import SwiftUI

@MainActor
final class EvolutionRequirementsSidebarViewViewModel: ObservableObject {
    let evolutionDetail: EvolutionDetail
    @Published private(set) var localizedEvolutionTriggerName: String?
    @Published private(set) var localizedItemName: String?
    @Published private(set) var localizedHeldItemName: String?
    @Published private(set) var localizedKnownMoveName: String?
    @Published private(set) var localizedKnownMoveType: String?
    @Published private(set) var localizedLocationName: String?
    @Published private(set) var localizedPartySpeciesName: String?
    @Published private(set) var localizedPartyTypeName: String?
    @Published private(set) var localizedTradeSpeciesName: String?
    private var settings: Settings?
    
    init(evolutionDetail: EvolutionDetail) {
        self.evolutionDetail = evolutionDetail
        Task {
            localizedEvolutionTriggerName = await getLocalizedTriggerName()
            localizedItemName = await getLocalizedItemName()
            localizedHeldItemName = await getLocalizedHeldItemName()
            localizedKnownMoveName = await getLocalizedKnownMove()
            localizedKnownMoveType = await getLocalizedKnowMoveType()
            localizedLocationName = await getLocalizedLocationName()
            localizedPartySpeciesName = await getLocalizedPartySpeciesName()
            localizedPartyTypeName = await getLocalizedPartyTypeName()
            localizedTradeSpeciesName = await getLocalizedTradeSpecies()
        }
    }
    
    func setUp(settings: Settings) {
        self.settings = settings
    }
    
    func getLocalizedTriggerName() async -> String? {
        guard let settings else { return nil }
        guard let trigger = try? await EvolutionTrigger.from(name: evolutionDetail.trigger.name) else {
            return nil
        }
        return trigger.names.localizedName(language: settings.language)
    }
    
    func getLocalizedHeldItemName() async -> String? {
        guard let heldItem = evolutionDetail.heldItem else { return nil }
        let item = try? await Item.from(name: heldItem.name)
        return item?.names.localizedName()
    }
    
    func getLocalizedItemName() async -> String? {
        guard let evolutionItem = evolutionDetail.item else {
            return nil
        }
        let item = try? await Item.from(name: evolutionItem.name)
        return item?.names.localizedName()
    }
    
    func getLocalizedKnownMove() async -> String? {
        guard let knownMove = evolutionDetail.knownMove else { return nil }
        let move = try? await Move.from(name: knownMove.name)
        return move?.names.localizedName()
    }
    
    func getLocalizedKnowMoveType() async -> String? {
        guard let knownMoveType = evolutionDetail.knownMoveType else { return nil }
        let moveType = try? await `Type`.from(name: knownMoveType.name)
        return moveType?.names.localizedName()
    }
    
    func getLocalizedLocationName() async -> String? {
        guard let locationResource = evolutionDetail.location else { return nil }
        let location = try? await Location.from(name: locationResource.name)
        return location?.names.localizedName()
    }
    
    func getLocalizedPartySpeciesName() async -> String? {
        guard let partySpecies = evolutionDetail.partySpecies else { return nil }
        let pokemonSpecies = try? await PokemonSpecies.from(name: partySpecies.name)
        return pokemonSpecies?.names.localizedName()
    }
    
    func getLocalizedPartyTypeName() async -> String? {
        guard let partyType = evolutionDetail.partyType else { return nil }
        let type = try? await `Type`.from(name: partyType.name)
        return type?.names.localizedName()
    }
    
    func getLocalizedTradeSpecies() async -> String? {
        guard let tradeSpecies = evolutionDetail.tradeSpecies else { return nil }
        let pokemonSpecies = try? await PokemonSpecies.from(name: tradeSpecies.name)
        return pokemonSpecies?.names.localizedName()
    }
}

