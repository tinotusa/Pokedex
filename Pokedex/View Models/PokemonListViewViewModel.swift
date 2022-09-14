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
    
    let limit = 20
    var offset = 0
    var page = 0 {
        didSet {
            offset = page * limit
        }
    }
    
    private var settings: Settings?
}

extension PokemonListViewViewModel {
    
    @MainActor
    func loadData(typePokmeonArray: [TypePokemon], settings: Settings) async {
        setUp(settings: settings)
        let pokemon = await getPokemon(typePokmeonArray: typePokmeonArray)
        let pokemonSpecies = await getPokemonSpecies(pokemonArray: pokemon)
        self.pokemon = pokemon
        self.pokemonSpecies = pokemonSpecies
        viewState = .loaded
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
    func setUp(settings: Settings) {
        self.settings = settings
    }
    
    func getPokemon(typePokmeonArray: [TypePokemon]) async -> [Pokemon] {
        await withTaskGroup(of: Pokemon?.self) { group in
            for (i, typePokmeon) in typePokmeonArray.enumerated() where i < limit {
                group.addTask {
                    return try? await Pokemon.from(url: typePokmeon.pokemon.url)
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
                    return try? await PokemonSpecies.from(name: pokemon.species.name)
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
}
