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
    
    init() {
        Task {
            await getAllPokemon()
        }
    }
    
    @MainActor
    func getPokemon() async {
        let pokemon = await Pokemon.from(name: searchText.lowercased())
        if let pokemon {
            self.pokemon.insert(pokemon)
        }
    }
    
    @MainActor
    private func getAllPokemon() async {
        isLoading = true
        await withTaskGroup(of: Pokemon?.self) { group in
            let resourceList = try? await PokeAPI.shared.getData(for: NamedAPIResourceList.self, url: URL(string: "https://pokeapi.co/api/v2/pokemon/?limit=50&offset=0")!)
            guard let resourceList else { return }
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
                        await viewModel.getPokemon()
                    }
                }
                
                ScrollView(showsIndicators: false) {
                    ForEach(viewModel.filteredPokemon) { pokemon in
                        NavigationLink(value: pokemon) {
                            PokemonRow(pokemon: pokemon)
                        }
                    }
                }
                .id(UUID())
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
    }
}
