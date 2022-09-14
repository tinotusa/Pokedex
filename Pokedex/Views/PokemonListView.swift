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
    let typePokemon: [TypePokemon]
    
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
                                await viewModel.loadData(typePokmeonArray: typePokemon, settings: settingsManager.settings)
                            }
                    case .loaded:
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

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView(
            title: "Hello world",
            id: 123,
            description: "some description",
            typePokemon: []
        )
        .environmentObject(SettingsManager())
    }
}
