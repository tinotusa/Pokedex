//
//  HomePokemonTabViewModel.swift
//  Pokedex
//
//  Created by Tino on 18/8/2022.
//

import SwiftUI

@MainActor
final class HomePokemonTabViewModel: ObservableObject {
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
    @Published var viewHasAppeared = false
    @Published var isLoading = false
    private var task: Task<Void, Never>?
    private let limit = 20
}

extension HomePokemonTabViewModel {
    func getPokemon(searchText: String) async {
        task?.cancel()
        print("am i called")
        if Task.isCancelled {
            print("task is cancelled \(#function)")
            return
        }
        if isLoading { return }

        task = Task {
            isLoading = true
            defer {
                Task { @MainActor in
                    isLoading = false
                }
            }
            
            let searchText = SearchBarViewModel.sanitizedSearchText(text: searchText)
            if searchText.isEmpty { return }
            
            if pokemon.containsItem(named: searchText) {
                return
            }
            
            guard let pokemon = try? await Pokemon.from(name: searchText) else {
                return
            }
            self.pokemon.insert(pokemon)
        }
    }
    
    func getPokemonList() async {
        await withTaskGroup(of: Pokemon?.self) { group in
            isLoading = true
            defer {
                Task { @MainActor in
                    self.isLoading = false
                }
            }
            
            let resourceList = try? await PokeAPI.shared.getResourceList(fromEndpoint: "pokemon", limit: limit)
            guard let resourceList else { return }
            if let nextURL = resourceList.next {
                nextPage = nextURL
            }
            
            for resouce in resourceList.results {
                group.addTask {
                    let pokemon = try? await Pokemon.from(name: resouce.name)
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
        isLoading = true
        defer {
            Task { @MainActor in
                self.isLoading = false
            }
        }
        let resourceList = try? await PokeAPI.shared.getData(for: NamedAPIResourceList.self, url: nextPage)
        
        guard let resourceList else { return }
        if let nextURL = resourceList.next {
            self.nextPage = nextURL
        }
        
        await withTaskGroup(of: Pokemon?.self) { group in
            for resouce in resourceList.results {
                group.addTask {
                    let pokemon = try? await Pokemon.from(name: resouce.name)
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
