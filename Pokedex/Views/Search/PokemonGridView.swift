//
//  PokemonGridView.swift
//  Pokedex
//
//  Created by Tino on 17/8/2022.
//

import SwiftUI
import Combine

struct PokemonGridView: View {
    @Binding private var searchSubmitted: Bool
    @Environment(\.searchText) private var searchText
    @StateObject private var viewModel = PokemonGridViewViewModel()
    @State private var hasSearched = true
    
    init(searchSubmitted: Binding<Bool>) {
        _searchSubmitted = searchSubmitted
    }
    
    private let columns: [GridItem] = [
        .init(.adaptive(minimum: 150))
    ]
              
    var body: some View {
        Group {
            if viewModel.pokemon.isEmpty {
                loadingView
            } else {
                pokemonGrid
            }
        }
        .task {
            await viewModel.getPokemonList()
        }
        .navigationDestination(for: Pokemon.self) { pokemon in
            PokemonDetail(pokemon: pokemon)
        }
        .onChange(of: searchSubmitted) { searchSubmitted in
            Task {
                await viewModel.getPokemon(searchText: searchText)
            }
        }
    }
}

private extension PokemonGridView {
    var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
    
    var pokemonGrid: some View {
        Group {
            if !searchText.isEmpty && viewModel.filteredPokemon(searchText: searchText).isEmpty {
                VStack {
                    Spacer()
                    Text("No pokemon named: \(searchText) in pokedex.")
                    Text("Try searching for it.")
                    Spacer()
                }
                .bodyStyle()
            }
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.filteredPokemon(searchText: searchText)) { pokemon in
                        NavigationLink(value: pokemon) {
                            PokemonCard(pokemon: pokemon)
                        }
                    }
                    
                    // if there is more data and user is not searching
                    if viewModel.hasNextPage && searchText.isEmpty {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .task {
                                await viewModel.getNextPokemonPage()
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    func submitSearch() async {
        defer { searchSubmitted = false }
        if searchText.isEmpty { return }
        Task {
            print("this is happening")
            await viewModel.getPokemon(searchText: searchText)
        }
    }
}


struct PokemonGridView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonGridView(searchSubmitted: .constant(false))
            .environmentObject(ImageLoader())
    }
}
