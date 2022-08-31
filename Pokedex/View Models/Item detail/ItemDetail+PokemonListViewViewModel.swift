//
//  ItemDetail+PokemonListViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 31/8/2022.
//

import Foundation

extension ItemDetail {
    @MainActor
    final class PokemonListViewViewModel: ObservableObject {
        @Published var viewHasAppeared = false
        @Published var pokemon = [Pokemon]()
        @Published var pokemonSpecies = [PokemonSpecies]()
        
        func loadData(itemHolderPokemon: [ItemHolderPokemon]) async {
            await getPokemon(itemHolderPokemon: itemHolderPokemon)
            await getPokemonSpecies(pokemonArray: pokemon)
        }
        
        func getPokemon(itemHolderPokemon: [ItemHolderPokemon]) async {
            await withTaskGroup(of: Pokemon?.self) { group in
                for itemHolder in itemHolderPokemon {
                    group.addTask {
                        let pokemon = try? await Pokemon.from(name: itemHolder.pokemon.name)
                        return pokemon
                    }
                }
                
                for await pokemon in group {
                    if let pokemon {
                        self.pokemon.append(pokemon)
                    }
                }
            }
        }
        
        func getPokemonSpecies(pokemonArray: [Pokemon]) async {
            await withTaskGroup(of: PokemonSpecies?.self) { group in
                for pokemon in pokemonArray {
                    group.addTask {
                        let pokemonSpecies = try? await PokemonSpecies.from(id: pokemon.id)
                        return pokemonSpecies
                    }
                }
                var tempSpecies = [PokemonSpecies]()
                for await pokemon in group {
                    if let pokemon {
                        tempSpecies.append(pokemon)
                    }
                }
                pokemonSpecies = tempSpecies
            }
        }
        
        func getPokemonSpecies(id: Int) -> PokemonSpecies? {
            pokemonSpecies.first {$0.id == id }
        }
    }
}
