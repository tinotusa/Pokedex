//
//  HomePokemonTab.swift
//  Pokedex
//
//  Created by Tino on 17/8/2022.
//

import SwiftUI

struct HomePokemonTab: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ObservedObject var viewModel: HomePokemonTabViewModel
    
    @State private var columns: [GridItem] = [
        .init(.adaptive(minimum: 150))
    ]

    var body: some View {
        ScrollView {
            if !viewModel.viewHasAppeared {
                LoadingView()
            } else if viewModel.state == .searching && viewModel.filteredPokemon.isEmpty {
                LoadingView(text: "Searching")
            } else if viewModel.state == .notFound {
                SearchErrorView(text: "\"\(viewModel.searchText)\" was not found.")
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
        .onChange(of: horizontalSizeClass) { horizontalSizeClass in
            setGridSize()
        }
    }
}

private extension HomePokemonTab {
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
    
    var pokemonGrid: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(viewModel.filteredPokemon) { pokemon in
                NavigationLink(value: pokemon) {
                    PokemonCard(pokemon: pokemon)
                }
            }
            
            // if there is more data and user is not searching
            if viewModel.hasNextPage && viewModel.state == .idle {
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

struct HomePokemonTab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomePokemonTab(viewModel: HomePokemonTabViewModel())
                .environmentObject(ImageCache())
        }
    }
}
