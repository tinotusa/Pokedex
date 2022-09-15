//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Tino on 14/9/2022.
//

import SwiftUI

struct PokemonListView: View {
    let title: String
    let id: Int
    let description: String
    let pokemonURLS: [URL]
    
    @StateObject private var viewModel = PokemonListViewViewModel()
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        VStack(alignment: .leading) {
            PopoverNavigationBar()
            
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading) {
                    HeaderWithID(title: title, id: id)
                    
                    Text(description)
                    Divider()
                    
                    switch viewModel.viewState {
                    case .loading:
                        LoadingView()
                            .task {
                                await viewModel.loadData(pokemonURLS: pokemonURLS, settings: settingsManager.settings)
                            }
                    case .loaded:
                        pokemonList
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

private extension PokemonListView {
    @ViewBuilder
    var pokemonList: some View {
        ForEach(viewModel.sortedPokemon) { pokemon in
            HStack {
                IconImage(url: pokemon.officialArtWork)
                if let pokemonSpecies = viewModel.getPokemonSpecies(withID: pokemon.id) {
                    Text(viewModel.localizedSpeciesName(for: pokemonSpecies))
                } else {
                    Text(pokemon.name)
                }
                Spacer()
                Text("\(pokemon.formattedID)")
                    .foregroundColor(.gray)
            }
        }
        if viewModel.hasNextPage {
            ProgressView()
                .task {
                    await viewModel.getNextPage()
                }
        }
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView(
            title: "Hello world",
            id: 123,
            description: "some description",
            pokemonURLS: []
        )
        .environmentObject(SettingsManager())
    }
}
