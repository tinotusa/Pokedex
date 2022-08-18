//
//  PokemonGridViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 18/8/2022.
//

import SwiftUI

@MainActor
final class PokemonGridViewViewModel: ObservableObject {
    @Published private(set) var pokemon: Set<Pokemon> = []
    @Published private(set) var nextPage: URL? {
        didSet {
            if nextPage != nil {
                hasNextPage = true
            } else {
                hasNextPage = false
            }
        }
    }
    @Published private(set) var hasNextPage: Bool = false
    private let limit = 20
}

extension PokemonGridViewViewModel {
    func getPokemon(searchText: String) async {
        if searchText.isEmpty { return }
        guard let pokemon = await Pokemon.from(name: searchText) else {
            return
        }
        self.pokemon.insert(pokemon)
    }
    
    func getPokemonList() async {
        await withTaskGroup(of: Pokemon?.self) { group in
            let resourceList = try? await PokeAPI.shared.getResourceList(fromEndpoint: "pokemon", limit: limit)
            guard let resourceList else { return }
            if let nextURL = resourceList.next {
                nextPage = nextURL
            }
            
            for resouce in resourceList.results {
                group.addTask {
                    let pokemon = await Pokemon.from(name: resouce.name)
                    return pokemon
                }
            }
            var temp = Set<Pokemon>()
            for await pokemon in group {
                if let pokemon {
                    temp.insert(pokemon)
                }
            }
            self.pokemon = temp
        }
    }
    
    func getNextPokemonPage() async {
        guard let nextPage else {
            return
        }
        
        let resourceList = try? await PokeAPI.shared.getData(for: NamedAPIResourceList.self, url: nextPage)
        
        guard let resourceList else { return }
        if let nextURL = resourceList.next {
            self.nextPage = nextURL
        }
        
        await withTaskGroup(of: Pokemon?.self) { group in
            for resouce in resourceList.results {
                group.addTask {
                    let pokemon = await Pokemon.from(name: resouce.name)
                    return pokemon
                }
            }
            var temp = Set<Pokemon>()
            for await pokemon in group {
                if let pokemon {
                    temp.insert(pokemon)
                }
            }
            self.pokemon = self.pokemon.union(temp)
            print("should have set something")
        }
    }
    
    func filteredPokemon(searchText: String) -> [Pokemon] {
        if searchText.isEmpty {
            return Array(pokemon).sorted()
        }
        return pokemon.filter { pokemon in
            if let id = Int(searchText) {
                return pokemon.id == id
            }
            return pokemon.name.contains(searchText)
        }
        .sorted()
    }
}
