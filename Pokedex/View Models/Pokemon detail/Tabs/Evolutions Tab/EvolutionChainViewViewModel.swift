//
//  EvolutionChainViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import SwiftUI

final class EvolutionChainViewViewModel: ObservableObject {
    let chainLink: ChainLink
    @Published private(set) var pokemonSpecies: PokemonSpecies?
    @Published private(set) var pokemon: Pokemon?
    @Published private(set) var evolutionTrigger: EvolutionTrigger?
    
    @MainActor
    init(chainLink: ChainLink) {
        self.chainLink = chainLink
        Task {
            pokemonSpecies = await PokemonSpecies.from(name: chainLink.species.name)
            pokemon = await Pokemon.from(name: chainLink.species.name)
            if let evolutionDetails = chainLink.evolutionDetails, !evolutionDetails.isEmpty {
                evolutionTrigger = await EvolutionTrigger.from(name: evolutionDetails.first!.trigger.name)
            }
        }
    }
    
    var localizedPokemonName: String {
        guard let pokemonSpecies else { return "Error" }
        return pokemonSpecies.names.localizedName() ?? "Error234"
    }
    
    var pokemonImageURL: URL? {
        return pokemon?.officialArtWork
    }
    
    var localizedEvolutionTriggerName: String {
        guard let evolutionTrigger else { return "Error" }
        return evolutionTrigger.names.localizedName() ?? "Error"
    }
}
