//
//  EvolutionChainLinkRowViewModel.swift
//  Pokedex
//
//  Created by Tino on 1/9/2022.
//

import Foundation

@MainActor
final class EvolutionChainLinkRowViewModel: ObservableObject {
    var chainLink: ChainLink?
    var settings: Settings = .default
    
    @Published var pokemon: Pokemon?
    @Published var pokemonSpecies: PokemonSpecies?
    @Published var viewHasAppeared = false
    
    func setUp(chainLink: ChainLink, settings: Settings = .default) {
        self.chainLink = chainLink
        self.settings = settings
    }
    
    func loadData() async {
        guard let chainLink else {
            #if DEBUG
            print("Error in \(#function). chainLink is nil.")
            #endif
            return
        }
        pokemonSpecies = try? await PokeAPI.shared.getData(for: PokemonSpecies.self, url: chainLink.species.url)
        guard let pokemonSpecies else {
            print("Error in \(#function). pokemonSpecies is nil.")
            return
        }
        pokemon = try? await Pokemon.from(id: pokemonSpecies.id)
    }
    
    var localizedPokemonName: String {
        guard let pokemonSpecies else { return "Error" }
        return pokemonSpecies.names.localizedName(language: settings.language, default: pokemonSpecies.name)
    }
    
}
