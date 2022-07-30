//
//  EvolutionsTabViewModel.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import Foundation

final class EvolutionsTabViewModel: ObservableObject {
    let pokemon: Pokemon
    @Published private(set) var pokemonSpecies: PokemonSpecies?
    @Published private(set) var evolutionChain: EvolutionChain?
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    @MainActor
    func setUp() async {
        pokemonSpecies = await PokemonSpecies.from(name: pokemon.name)
        guard let evolutionChainURL = pokemonSpecies?.evolutionChain?.url else {
            return
        }
        evolutionChain = try? await PokeAPI.getData(for: EvolutionChain.self, url: evolutionChainURL)
    }
}
