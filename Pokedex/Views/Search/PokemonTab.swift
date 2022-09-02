//
//  PokemonTab.swift
//  Pokedex
//
//  Created by Tino on 17/8/2022.
//

import SwiftUI
import Combine

struct PokemonTab: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @EnvironmentObject private var viewModel: PokemonGridViewViewModel
    @EnvironmentObject private var searchBar: SearchBarViewModel
    
    @State private var columns: [GridItem] = [
        .init(.adaptive(minimum: 150))
    ]
              
    var body: some View {
        Group {
            if !viewModel.viewHasAppeared {
                LoadingView()
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
        .onReceive(
            searchBar.$searchText
                .debounce(
                    for: 0.8,
                    scheduler: RunLoop.main
                )
        ) { searchText in
            Task {
                await viewModel.getPokemon(searchText: searchText)
            }
        }
    }
}

private extension PokemonTab {
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
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.filteredPokemon(searchText: searchBar.sanitizedSearchText)) { pokemon in
                    NavigationLink(destination: PokemonDetail(pokemon: pokemon)) {
                        PokemonCard(pokemon: pokemon)
                    }
                }
                
                // if there is more data and user is not searching
                if viewModel.hasNextPage && searchBar.isEmpty {
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


struct PokemonTab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PokemonTab()
                .environmentObject(ImageCache())
                .environmentObject(PokemonGridViewViewModel())
                .environmentObject(SearchBarViewModel())
        }
    }
}
