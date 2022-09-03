//
//  ItemPokemonListViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 31/8/2022.
//

import Foundation


@MainActor
final class ItemPokemonListViewViewModel: ObservableObject {
    @Published var viewHasAppeared = false
    @Published private var pokemon = [Pokemon]()
    @Published private var pokemonSpecies = [PokemonSpecies]()
}


extension ItemPokemonListViewViewModel {
    var sortedPokemon: [Pokemon] {
        pokemon.sorted()
    }
}

extension ItemPokemonListViewViewModel {
    func loadData(itemHolderPokemon: [ItemHolderPokemon]) async {
        await getPokemon(itemHolderPokemon: itemHolderPokemon)
        await getPokemonSpecies(pokemonArray: pokemon)
    }
    
    func getPokemon(itemHolderPokemon: [ItemHolderPokemon]) async {
        await withTaskGroup(of: Pokemon?.self) { group in
            for itemHolder in itemHolderPokemon {
                group.addTask {
                    let pokemon = try? await PokeAPI.shared.getData(for: Pokemon.self, url: itemHolder.pokemon.url)
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
//                        let pokemonSpecies = try? await PokemonSpecies.from(id: pokemon.id)
                    let pokemonSpecies = try? await PokeAPI.shared.getData(for: PokemonSpecies.self, url: pokemon.species.url)
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
    
    func getPokemonSpecies(named name: String) -> PokemonSpecies? {
        pokemonSpecies.first {$0.name == name }
    }
}
