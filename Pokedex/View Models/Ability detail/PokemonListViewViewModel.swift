//
//  PokemonListViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 26/8/2022.
//

import Foundation
extension AbilityDetail {
    @MainActor
    final class PokemonListViewViewModel: ObservableObject {
        @Published private(set) var pokemon = Set<Pokemon>()
        @Published private(set) var pokemonSpecies = Set<PokemonSpecies>()
        @Published private(set) var isLoading = false
    }
}

extension AbilityDetail.PokemonListViewViewModel {
    func loadPokemon(from abilityPokemonArray: [AbilityPokemon]) async -> Set<Pokemon> {
        await withTaskGroup(of: Pokemon?.self) { group in
            for abilityPokemon in abilityPokemonArray {
                group.addTask {
                    return try? await Pokemon.from(name: abilityPokemon.pokemon.name)
                }
            }
            var tempPokemon = Set<Pokemon>()
            for await pokemon in group {
                if let pokemon {
                    tempPokemon.insert(pokemon)
                }
            }
            return pokemon.union(tempPokemon)
        }
    }
    
    func loadPokemonSpecies(from pokemonArray: [Pokemon]) async -> Set<PokemonSpecies> {
        await withTaskGroup(of: PokemonSpecies?.self) { group in
            for pokemon in pokemonArray {
                group.addTask {
                    return try? await PokemonSpecies.from(name: pokemon.species.name)
                }
            }
            var tempPokemon = Set<PokemonSpecies>()
            for await pokemon in group {
                if let pokemon {
                    tempPokemon.insert(pokemon)
                }
            }
            return pokemonSpecies.union(tempPokemon)
        }
    }
    
    func loadData(from abilityPokemonArray: [AbilityPokemon]) async {
        isLoading = true
        defer { isLoading = false }
        
        async let pokemon = loadPokemon(from: abilityPokemonArray)
        self.pokemon = await pokemon
        async let pokemonSpecies = loadPokemonSpecies(from: Array(self.pokemon))
        await self.pokemonSpecies = pokemonSpecies
    }
    
    func pokemonSpecies(name: String) -> PokemonSpecies? {
        pokemonSpecies.first { $0.name == name }
    }
    
    var filteredPokemon: [Pokemon] {
        pokemon.sorted()
    }
}
