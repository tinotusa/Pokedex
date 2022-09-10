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
    
    @Published private(set) var viewState = ViewState.loading
}

extension PokemonEvolutionsTabViewModel {
    func loadData(pokemon: Pokemon) async {
        setUp(pokemon: pokemon)
        do {
            pokemonSpecies = try await PokemonSpecies.from(name: pokemon.species.name)
            guard let evolutionChainURL = pokemonSpecies?.evolutionChain?.url else {
                print("Error in \(#function). Failed to get evolutoin chain url.")
                viewState = .empty
                return
            }
            evolutionChain = try await PokeAPI.shared.getData(for: EvolutionChain.self, url: evolutionChainURL)
            getAllChains()
            viewState = .loaded
        } catch {
            #if DEBUG
            print("Error in \(#function).\n\(error)")
            #endif
            viewState = .error(error)
        }
    }
}

private extension PokemonEvolutionsTabViewModel {
    func setUp(pokemon: Pokemon) {
        self.pokemon = pokemon
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
