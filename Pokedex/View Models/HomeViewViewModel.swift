//
//  HomeViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 5/8/2022.
//

import Foundation

final class HomeViewViewModel: ObservableObject {
    @Published private(set) var pokemon: Set<Pokemon> = []
    @Published var searchText = "" {
        didSet {
            if searchText != oldValue || searchText.isEmpty { foundPokemon = nil }
        }
    }
    @Published var isLoading = false
    @Published var hasNextPage = false
    @Published var foundPokemon: Bool?
    
    private let limit = 50
    private var nextPage: URL?

    init() {
        Task {
            await getPokemon()
        }
    }
    
    /// Searches for a pokemon based on the (lowercased) `searchText`
    /// - returns: `True` if it found the pokemon, `False` otherwise.
    @MainActor
    func searchPokemon() async -> Bool {
        let pokemon = await Pokemon.from(name: searchText.lowercased())
        if let pokemon {
            self.pokemon.insert(pokemon)
            return true
        }
        return false
    }
    
    @MainActor
    func getNextPokemonPage() async {
        isLoading = true
        
        guard let nextPage else { return }
        
        let resourceList = try? await PokeAPI.shared.getData(for: NamedAPIResourceList.self, url: nextPage)
        
        guard let resourceList else { return }
        if let nextURLString = resourceList.next {
            self.nextPage = URL(string: nextURLString)
            hasNextPage = true
        } else {
            hasNextPage = false
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
            isLoading = false
        }
    }
    
    @MainActor
    func getPokemon() async {
        isLoading = true
        await withTaskGroup(of: Pokemon?.self) { group in
            let baseAPIURL = URL(string: "https://pokeapi.co/api/v2")!
            var request = URLRequest(url: baseAPIURL.appendingPathComponent("pokemon"))
            let queryItems: [URLQueryItem] = [
                .init(name: "offset", value: "0"),
                .init(name: "limit", value: "\(limit)")
            ]
            request.url?.append(queryItems: queryItems)
            let url = request.url
            
            guard let url else { return }
            
            let resourceList = try? await PokeAPI.shared.getData(for: NamedAPIResourceList.self, url: url)
            guard let resourceList else { return }
            if let nextURLString = resourceList.next {
                nextPage = URL(string: nextURLString)
                hasNextPage = true
            } else {
                hasNextPage = false
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
            isLoading = false
        }
    }
    
    var isSearching: Bool {
        !searchText.isEmpty
    }
    
    var filteredPokemon: [Pokemon] {
        if searchText.isEmpty {
            return Array(pokemon).sorted()
        }
        let filteredPokemon = pokemon.filter { pokemon in
            if let id = Int(searchText) {
                return pokemon.id == id
            }
            return pokemon.name.contains(searchText.lowercased())
        }
        return filteredPokemon.sorted()
    }
}
