//
//  MovePokemonListViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 14/9/2022.
//

import Foundation

final class MovePokemonListViewViewModel: ObservableObject {
    @Published private var pokemon = [Pokemon]()
    @Published private(set) var pokemonSpecies = [PokemonSpecies]()
    @Published private(set) var viewState = ViewState.loading
    
    @Published private(set) var hasNextPage = true
    private let limit = 20
    private var offset = 0
    private var page = 0 {
        didSet {
            offset = page * limit
        }
    }
    private var settings: Settings?
    private var learnedByPokemon = [NamedAPIResource]()
}

private extension MovePokemonListViewViewModel {
    func setUp(settings: Settings, learnedByPokemon: [NamedAPIResource]) {
        self.settings = settings
        self.learnedByPokemon = learnedByPokemon
    }
}

extension MovePokemonListViewViewModel {
    var sortedPokemon: [Pokemon] {
        pokemon.sorted()
    }
    @MainActor
    private func getPokemon() async -> [Pokemon] {
        await withTaskGroup(of: Pokemon?.self) { group in
            for (i, pokemon) in learnedByPokemon.enumerated() where i < limit {
                group.addTask {
                    return try? await Pokemon.from(name: pokemon.name)
                }
            }
            var tempPokemon = [Pokemon]()
            for await pokemon in group {
                if let pokemon {
                    tempPokemon.append(pokemon)
                }
            }
            
            if tempPokemon.count < limit {
                hasNextPage = false
            }
            
            return tempPokemon
        }
    }
    
    @MainActor
    private func getPokemonSpecies() async -> [PokemonSpecies] {
        await withTaskGroup(of: PokemonSpecies?.self) { group in
            for (i, pokemon) in learnedByPokemon.enumerated() where i < limit {
                group.addTask {
                    return try? await PokemonSpecies.from(name: pokemon.name)
                }
            }
            var tempPokemonSpecies = [PokemonSpecies]()
            for await pokemonSpecies in group {
                if let pokemonSpecies {
                    tempPokemonSpecies.append(pokemonSpecies)
                }
            }
            
            if tempPokemonSpecies.count < limit {
                hasNextPage = false
            }
            return tempPokemonSpecies
        }
    }
    
    @MainActor
    func loadData(learnedByPokemon: [NamedAPIResource], settings: Settings) async {
        setUp(settings: settings, learnedByPokemon: learnedByPokemon)
        if learnedByPokemon.isEmpty {
            viewState = .empty
            return
        }
        async let pokemon = await getPokemon()
        async let pokemonSpecies = await getPokemonSpecies()
        self.pokemon = await pokemon
        self.pokemonSpecies = await pokemonSpecies
        
        page += 1
        
        viewState = .loaded
    }
    
    @MainActor
    func getNextPage() async {
        let pokemon = await getNextPokemonPage()
        await getNextPokemonSpeciesPage(pokemon: pokemon)
        self.pokemon.append(contentsOf: pokemon)
        page += 1
    }
    
    @MainActor
    func getNextPokemonPage() async -> [Pokemon] {
        await withTaskGroup(of: Pokemon?.self) { group in
            for i in offset ..< learnedByPokemon.count where i < offset + limit {
                group.addTask {
                    let pokemon = self.learnedByPokemon[i]
                    print("nextPage offset: \(i)")
                    return try? await Pokemon.from(url: pokemon.url)
                    
                }
            }
            
            var count = 0
            var tempPokemon = [Pokemon]()
            for await pokemon in group {
                if let pokemon {
                    tempPokemon.append(pokemon)
                    count += 1
                }
            }
            if count < limit {
                print("nextPage count is \(count)")
                hasNextPage = false
            }
            return tempPokemon
        }
    }
    
    @MainActor
    func getNextPokemonSpeciesPage(pokemon: [Pokemon]) async {
        print("next pokemon species: called")
        await withTaskGroup(of: PokemonSpecies?.self) { group in
            for pokemon in pokemon {
                group.addTask {
                    do {
                        return try await PokemonSpecies.from(url: pokemon.species.url)
                    } catch {
                        #if DEBUG
                        print("Error in \(#function).\n\(error)")
                        #endif
                    }
                    return nil
                }
            }
            
            var tempPokemonSpecies = [PokemonSpecies]()
            for await pokemonSpecies in group {
                if let pokemonSpecies {
                    tempPokemonSpecies.append(pokemonSpecies)
                }
            }
            self.pokemonSpecies.append(contentsOf: tempPokemonSpecies)
        }
    }
}
