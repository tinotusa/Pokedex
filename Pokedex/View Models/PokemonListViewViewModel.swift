//
//  PokemonListViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 14/9/2022.
//

import Foundation

final class PokemonListViewViewModel: ObservableObject {
    @Published private var pokemon = [Pokemon]()
    @Published private var pokemonSpecies = [PokemonSpecies]()
    @Published private(set) var viewState = ViewState.loading
    @Published private(set) var hasNextPage = true
    
    let limit = 20
    var offset = 0
    var page = 0 {
        didSet {
            offset = page * limit
        }
    }
    
    private var settings: Settings?
    private var typePokemonArray = [TypePokemon]()
}

extension PokemonListViewViewModel {
    @MainActor
    func loadData(typePokemonArray: [TypePokemon], settings: Settings) async {
        setUp(settings: settings, typePokemonArray: typePokemonArray)
        
        let pokemon = await getPokemon(typePokmeonArray: typePokemonArray)
        let pokemonSpecies = await getPokemonSpecies(pokemonArray: pokemon)
        self.pokemon = pokemon
        self.pokemonSpecies = pokemonSpecies
        
        if pokemon.count < limit {
            hasNextPage = false
        }
        
        page += 1
        
        viewState = .loaded
    }
    
    @MainActor
    func getNextPage() async {
        let pokemon = await getNextPokemonPage()
        let pokemonSpecies = await getNextPokemonSpeciesPage(pokemon: pokemon)
        self.pokemon.append(contentsOf: pokemon)
        self.pokemonSpecies.append(contentsOf: pokemonSpecies)
        
        if pokemon.count < limit {
            hasNextPage = false
        }
        page += 1
    }
    
    func getPokemonSpecies(withID id: Int) -> PokemonSpecies? {
        pokemonSpecies.first { $0.id == id }
    }
    
    func localizedSpeciesName(for species: PokemonSpecies) -> String {
        species.names.localizedName(language: settings?.language, default: species.name)
    }
    
    var sortedPokemon: [Pokemon] {
        pokemon.sorted()
    }
}

private extension PokemonListViewViewModel {
    func setUp(settings: Settings, typePokemonArray: [TypePokemon]) {
        self.settings = settings
        self.typePokemonArray = typePokemonArray
    }
    
    func getPokemon(typePokmeonArray: [TypePokemon]) async -> [Pokemon] {
        await withTaskGroup(of: Pokemon?.self) { group in
            for (i, typePokemon) in typePokmeonArray.enumerated() where i < limit {
                group.addTask {
                    do {
                        return try await Pokemon.from(url: typePokemon.pokemon.url)
                    } catch {
                        #if DEBUG
                        print("Error in \(#function).\n\(error)")
                        #endif
                    }
                    return nil
                }
            }
            var tempPokemon = [Pokemon]()
            for await pokemon in group {
                guard let pokemon else { continue }
                tempPokemon.append(pokemon)
            }
            return tempPokemon
        }
    }
    
    func getPokemonSpecies(pokemonArray: [Pokemon]) async -> [PokemonSpecies] {
        await withTaskGroup(of: PokemonSpecies?.self) { group in
            for pokemon in pokemonArray {
                group.addTask {
                    do {
                        return try await PokemonSpecies.from(name: pokemon.species.name)
                    } catch {
                        #if DEBUG
                        print("Error in \(#function).\n\(error)")
                        #endif
                    }
                    return nil
                }
            }
            var tempPokemonSpecies = [PokemonSpecies]()
            for await pokemon in group {
                guard let pokemon else { continue }
                tempPokemonSpecies.append(pokemon)
            }
            return tempPokemonSpecies
        }
    }
    
    func getNextPokemonPage() async -> [Pokemon] {
        return await withTaskGroup(of: Pokemon?.self) { group in
            for (i, typePokemon) in typePokemonArray.enumerated()
                where i >= offset && i < offset + limit
            {
                group.addTask {
                    do {
                        return try await Pokemon.from(url: typePokemon.pokemon.url)
                    } catch {
                        #if DEBUG
                        print("Error in \(#function).\n\(error)")
                        #endif
                    }
                    return nil
                }
            }
            var pokemonArray = [Pokemon]()
            for await pokemon in group {
                guard let pokemon else { continue }
                pokemonArray.append(pokemon)
            }
            return pokemonArray
        }
    }
    
    func getNextPokemonSpeciesPage(pokemon:  [Pokemon]) async -> [PokemonSpecies] {
        await withTaskGroup(of: PokemonSpecies?.self) { group in
            for pokemon in pokemon {
                group.addTask {
                    try? await PokemonSpecies.from(url: pokemon.species.url)
                }
            }
            var pokemonSpeciesArray = [PokemonSpecies]()
            for await pokemonSpecies in group {
                guard let pokemonSpecies else { continue }
                pokemonSpeciesArray.append(pokemonSpecies)
            }
            return pokemonSpeciesArray
        }
    }
}
