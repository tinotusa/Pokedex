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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @EnvironmentObject private var viewModel: PokemonGridViewViewModel
    
    init(searchSubmitted: Binding<Bool>) {
        _searchSubmitted = searchSubmitted
    }
    
    @State private var columns: [GridItem] = [
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
            if !viewModel.viewHasAppeared {
                await viewModel.getPokemonList()
                print("loaded the pokemon")
                viewModel.viewHasAppeared = true
            }
        }
        .navigationDestination(for: Pokemon.self) { pokemon in
            PokemonDetail(pokemon: pokemon)
        }
        .onChange(of: horizontalSizeClass) { horizontalSizeClass in
            setGridSize()
        }
        .onChange(of: searchSubmitted) { searchSubmitted in
            Task {
                await viewModel.getPokemon(searchText: searchText)
            }
        }
    }
}

private extension PokemonGridView {
    func setGridSize() {
        print("called")
        if horizontalSizeClass == .compact {
            print("is compact")
            columns = [
                .init(.adaptive(minimum: 250))
            ]
        }
        if horizontalSizeClass == .regular {
            print("is regular")
            columns = [
                .init(.adaptive(minimum: 150))
                
            ]
        }
    }
    
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
                        NavigationLink(destination: PokemonDetail(pokemon: pokemon)) {
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
        NavigationStack {
            PokemonGridView(searchSubmitted: .constant(false))
                .environmentObject(ImageCache())
                .environmentObject(PokemonGridViewViewModel())
        }
    }
}
