//
//  PokemonSpeciesListView.swift
//  Pokedex
//
//  Created by Tino on 21/9/2022.
//

import SwiftUI

struct PokemonSpeciesListView: View {
    let title: String
    let id: Int
    let description: LocalizedStringKey
    let pokemonSpeciesURLS: [URL]
    
    @StateObject private var viewModel = PokemonSpeciesListViewViewModel()
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        VStack(alignment: .leading) {
            HeaderBar() {
                
            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    HeaderWithID(title: title, id: id)
                    
                    Text(description)
                    Divider()
                    
                    switch viewModel.viewState {
                    case .loading:
                        LoadingView()
                            .task {
                                await viewModel.loadData(
                                    urls: pokemonSpeciesURLS,
                                    settings: settingsManager.settings
                                )
                            }
                    case .loaded:
                        pokemonList
                    case .empty:
                        NoDataView(text: "No pokemon species to load.")
                    case .error(let error):
                        ErrorView(text: error.localizedDescription)
                    }
                }
            }
        }
        .padding()
        .bodyStyle()
        .foregroundColor(.textColour)
        .backgroundColour()
        .toolbar(.hidden)
    }
}

private extension PokemonSpeciesListView {
    @ViewBuilder
    var pokemonList: some View {
        LazyVStack {
            ForEach(viewModel.pokemonSpecies) { pokemonSpecies in
                if let pokemon = viewModel.getPokemon(withID: pokemonSpecies.id) {
                    HStack {
                        IconImage(url: pokemon.officialArtWork)
                        VStack(alignment: .leading, spacing: 0) {
                            Text(viewModel.localizedPokemonName(pokemonSpecies: pokemonSpecies))
                            HStack {
                                ForEach(pokemon.types, id: \.self) { type in
                                    PokemonTypeTag(pokemonType: type)
                                }
                            }
                        }
                        Spacer()
                        Text(pokemon.formattedID)
                            .foregroundColor(.gray)
                    }
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
}


struct PokemonSpeciesListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonSpeciesListView(
            title: "testing",
            id: 123,
            description: "hello world",
            pokemonSpeciesURLS: Generation.example.pokemonSpecies.map { $0.url }
        )
        .environmentObject(SettingsManager())
        .environmentObject(ImageCache())
    }
}
