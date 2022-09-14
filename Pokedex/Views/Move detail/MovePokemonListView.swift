//
//  MovePokemonListView.swift
//  Pokedex
//
//  Created by Tino on 11/9/2022.
//

import SwiftUI

struct MovePokemonListView: View {
    let move: Move
    var description: String
    
    @StateObject private var viewModel = MovePokemonListViewViewModel()
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        VStack {
            PopoverNavigationBar()
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading) {
                    HeaderWithID(title: move.name, id: move.id)
                    
                    Text(description)
                    Divider()
                    
                    switch viewModel.viewState {
                    case .loading:
                        LoadingView()
                            .task {
                                await viewModel.loadData(learnedByPokemon: move.learnedByPokemon, settings: settingsManager.settings)
                            }
                    case .loaded:
                        pokemonList
                    case .empty:
                        Text("No pokemon.")
                    default:
                        Text("Error loading.")
                    }
                }
            }
        }
        .padding()
        .bodyStyle()
        .foregroundColor(.textColour)
        .backgroundColour()
    }
}

private extension MovePokemonListView {
    @ViewBuilder
    var pokemonList: some View {
        ForEach(viewModel.sortedPokemon) { pokemon in
            HStack {
                ImageLoaderView(url: pokemon.iconURL) {
                    ProgressView()
                } content: { image in
                    image
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 50, height: 50)
                if let pokemonSpecies = viewModel.pokemonSpecies.first(where: { $0.name == pokemon.species.name }) {
                    Text(pokemonSpecies.names.localizedName(language: settingsManager.settings.language, default: pokemonSpecies.name))
                }

                Spacer()

                Text(pokemon.formattedID)
                    .foregroundColor(.gray)
            }
        }
        if viewModel.hasNextPage {
            ProgressView()
                .task {
                    await viewModel.getNextPage()
                }
                .onDisappear {
                    print("nextPage disappeared")
                }
        }
    }
}

struct MovePokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        MovePokemonListView(move: .example, description: "some description here")
            .environmentObject(ImageCache())
            .environmentObject(SettingsManager())
    }
}
