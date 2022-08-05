//
//  HomeView.swift
//  Pokedex
//
//  Created by Tino on 3/8/2022.
//

import SwiftUI

final class HomeViewViewModel: ObservableObject {
    @Published var pokemon: Set<Pokemon> = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var hasNextPage = false
    private let limit = 50
    private var nextPage: URL?

    init() {
        Task {
            await getPokemon()
        }
    }
    
    @MainActor
    func searchPokemon() async {
        let pokemon = await Pokemon.from(name: searchText.lowercased())
        if let pokemon {
            self.pokemon.insert(pokemon)
        }
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
    private func getPokemon() async {
        isLoading = true
        await withTaskGroup(of: Pokemon?.self) { group in
            let baseAPIURL = URL(string: "https://pokeapi.co/api/v2")!
            var request = URLRequest(url: baseAPIURL.appendingPathComponent("pokemon"))
            let queryItems: [URLQueryItem] = [
                .init(name: "limit", value: "\(limit)"),
                .init(name: "offset", value: "0")
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

struct HomeView: View {
    @StateObject private var viewModel = HomeViewViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(placeholder: "Search for pokemon", text: $viewModel.searchText) {
                    Task {
                        await viewModel.searchPokemon()
                    }
                }
                
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(viewModel.filteredPokemon) { pokemon in
                            NavigationLink(value: pokemon) {
                                PokemonRow(pokemon: pokemon)
                            }
                        }
                        if viewModel.hasNextPage {
                            ProgressView()
                                .task {
                                    await viewModel.getNextPokemonPage()
                                }
                        }
                    }
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .padding()
            .background {
                Color.backgroundColour
                    .ignoresSafeArea()
            }
            .navigationDestination(for: Pokemon.self) { pokemon in
                PokemonDetail(pokemon: pokemon)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ImageLoader())
    }
}
