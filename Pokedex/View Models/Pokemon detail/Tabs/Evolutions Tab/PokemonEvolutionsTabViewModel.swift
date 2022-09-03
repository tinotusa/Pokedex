//
//  PokemonEvolutionsTabViewModel.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import Foundation

@MainActor
final class PokemonEvolutionsTabViewModel: ObservableObject {
    var pokemon: Pokemon?
    
    @Published private(set) var pokemonSpecies: PokemonSpecies?
    @Published private(set) var evolutionChain: EvolutionChain?
    @Published private(set) var evolutionChainLinks = [ChainLink]()
    
    @Published var viewHasAppeared = false
}

extension PokemonEvolutionsTabViewModel {
    func setUp(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    func loadData() async {
        pokemonSpecies = try? await PokemonSpecies.from(name: wrappedPokemon.species.name)
        guard let evolutionChainURL = pokemonSpecies?.evolutionChain?.url else {
            print("Error in \(#function). Failed to get evolutoin chain url.")
            return
        }
        evolutionChain = try? await PokeAPI.shared.getData(for: EvolutionChain.self, url: evolutionChainURL)
    }
    
    func getAllChains() {
        guard let evolutionChain else {
            return
        }
        var stack = [evolutionChain.chain]
        var temp = [ChainLink]()
        while !stack.isEmpty {
            guard let link = stack.popLast() else { break }
            temp.append(link)
            stack.append(contentsOf: link.evolvesTo)
        }
        evolutionChainLinks = temp
    }
}

private extension PokemonEvolutionsTabViewModel {
    var wrappedPokemon: Pokemon {
        if let pokemon {
            return pokemon
        }
        fatalError("Error pokemon is nil. Call setUp(pokemon:) before calling other view model functions.")
    }
    
}
