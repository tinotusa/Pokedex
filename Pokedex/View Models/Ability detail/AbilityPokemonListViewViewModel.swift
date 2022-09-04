//
//  AbilityPokemonListViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 26/8/2022.
//

import Foundation

@MainActor
final class AbilityPokemonListViewViewModel: ObservableObject {
    @Published private(set) var pokemon = [Pokemon]()
    @Published private(set) var pokemonSpecies = [PokemonSpecies]()

    @Published private(set) var isLoading = false
    @Published private(set) var hasNextPage = true
    @Published var viewHasAppeared = false
    
    private let limit = 10
    private var offset = 0
    private var page = 0 {
        didSet {
            offset = page * limit
        }
    }
}


extension AbilityPokemonListViewViewModel {
    func getPokemonAndSpecies(from abilityPokemonArray: [AbilityPokemon]) async {
        await withTaskGroup(of: Pokemon?.self) { group in
            for (i, pokemonAbility) in abilityPokemonArray.enumerated()
                where i < limit
            {
                group.addTask {
                    return try? await Pokemon.from(url: pokemonAbility.pokemon.url)
                }
            }
            var count = 0
            for await pokemon in group {
                guard let pokemon else { continue }
                
                let pokemonSpecies = try? await PokemonSpecies.from(url: pokemon.species.url)
                guard let pokemonSpecies else { continue }
                
                self.pokemon.append(pokemon)
                self.pokemonSpecies.append(pokemonSpecies)
                count += 1
            }
            if count < limit {
                hasNextPage = false
            } else {
                hasNextPage = true
            }
            page += 1
        }
    }

    func getNextPokemonAndSpeciesPage(abilityPokemonArray: [AbilityPokemon]) async {
        await withTaskGroup(of: Pokemon?.self) { group in
            for i in offset ..< abilityPokemonArray.count where i < offset + limit {
                if i > abilityPokemonArray.count { break }
                group.addTask {
                    let abilityPokemon = abilityPokemonArray[i]
                    return try? await Pokemon.from(url: abilityPokemon.pokemon.url)
                }
            }
            var count = 0
            var tempPokemon = [Pokemon]()
            var tempPokemonSpecies = [PokemonSpecies]()
            
            for await pokemon in group {
                guard let pokemon else { continue }
                
                let pokemonSpecies = try? await PokemonSpecies.from(url: pokemon.species.url)
                guard let pokemonSpecies else { continue }
                
                tempPokemon.append(pokemon)
                tempPokemonSpecies.append(pokemonSpecies)
                count += 1
            }
            if count < limit {
                hasNextPage = false
            } else {
                hasNextPage = true
            }
            self.pokemon.append(contentsOf: tempPokemon)
            self.pokemonSpecies.append(contentsOf: tempPokemonSpecies)
            page += 1
        }
    }
    
    func pokemonSpecies(named name: String) -> PokemonSpecies? {
        self.pokemonSpecies.first(where: { $0.name == name })
    }
}
