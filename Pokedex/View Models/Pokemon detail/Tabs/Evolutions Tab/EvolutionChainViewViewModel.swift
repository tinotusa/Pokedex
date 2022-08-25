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
            pokemonSpecies = try? await PokemonSpecies.from(name: chainLink.species.name)
            if let pokemonSpecies {
                pokemon = try? await Pokemon.from(id: pokemonSpecies.id)
            } else {
                print("Error in \(#function). pokemonSpecies is nil.")
            }
            if let evolutionDetails = chainLink.evolutionDetails, !evolutionDetails.isEmpty {
                evolutionTrigger = try? await EvolutionTrigger.from(name: evolutionDetails.first!.trigger.name)
            }
        }
    }
    
    var localizedPokemonName: String {
        guard let pokemonSpecies else { return "Error" }
        return pokemonSpecies.names.localizedName(default: "Error")
    }
    
    var pokemonImageURL: URL? {
        return pokemon?.officialArtWork
    }
    
    var localizedEvolutionTriggerName: String {
        guard let evolutionTrigger else { return "Error" }
        return evolutionTrigger.names.localizedName(default: "Error")
    }
}
