//
//  HomePokemonTabViewModel.swift
//  Pokedex
//
//  Created by Tino on 18/8/2022.
//

import SwiftUI
import Combine

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
    @Published var viewState = ViewState.loading
    @Published var searchState = SearchState.idle
    @Published var searchText = "" {
        didSet {
            #if DEBUG
            print("Search text: \(searchText)")
            #endif
            Task {
                await getPokemon()
            }
        }
    }
    private var task: Task<Void, Never>?
    private let limit = 20
}

extension HomePokemonTabViewModel {
    enum State {
        case idle
        case searching
        case found
        case notFound
    }
    
    var filteredPokemon: [Pokemon] {
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

extension HomePokemonTabViewModel {
    private func resetSearchState() {
        searchState = .idle
    }
    
    func getPokemon() async {
        resetSearchState()
        
        task?.cancel()
        
        if Task.isCancelled {
            #if DEBUG
            print("task is cancelled \(#function)")
            #endif
            return
        }
        if searchText.isEmpty {
            #if DEBUG
            print("empty search text")
            #endif
            return
        }

        searchState = .searching
        
        task = Task {
            if pokemon.containsItem(named: searchText) {
                searchState = .done
                return
            }
            
            guard let pokemon = try? await Pokemon.from(name: searchText) else {
                searchState = .error
                print("searchText: \(searchText) func getPokemon")
                return
            }
            self.pokemon.insert(pokemon)
            print("The pokemon is: \(pokemon.name)")
            searchState = .done
        }
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
            viewState = .loaded
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
}
