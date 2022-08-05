//
//  HomeView.swift
//  Pokedex
//
//  Created by Tino on 3/8/2022.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewViewModel()
    
    let columns: [GridItem] = [
        .init(.adaptive(minimum: 180)),
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(placeholder: "Search for pokemon", text: $viewModel.searchText) {
                    Task {
                        viewModel.foundPokemon = await viewModel.searchPokemon()
                    }
                }
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns) {
                        if let foundPokemon = viewModel.foundPokemon, !foundPokemon {
                            VStack {
                                Text("No pokemon by that name was found.")
                            }
                        } else if !viewModel.isLoading && viewModel.filteredPokemon.isEmpty {
                            VStack {
                                Text("\(viewModel.searchText) is not in the current Pokedex.")
                                Text("Try searching for it.")
                            }
                        } else {
                            ForEach(viewModel.filteredPokemon) { pokemon in
                                NavigationLink(value: pokemon) {
                                    PokemonCard(pokemon: pokemon)
                                }
                            }
                        }
                        if viewModel.hasNextPage && !viewModel.isSearching {
                            ProgressView()
                                .task {
                                    await viewModel.getNextPokemonPage()
                                }
                        }
                    }
                }
                .scrollDismissesKeyboard(.immediately)
                .refreshable {
                    Task {
                        await viewModel.getPokemon()
                    }
                }
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
