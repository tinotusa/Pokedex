//
//  EvolutionChainLinkRow.swift
//  Pokedex
//
//  Created by Tino on 1/9/2022.
//

import SwiftUI

struct EvolutionChainLinkRow: View {
    let chainLink: ChainLink
    @StateObject var viewModel = EvolutionChainLinkRowViewModel()
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        switch viewModel.viewState {
        case .loading:
            LoadingView()
                .task {
                    await viewModel.loadData(chainLink: chainLink, settings: settingsManager.settings)
                }
        case .loaded:
            evolutionChainLinkRow
        case .error(let error):
            Text(error.localizedDescription)
        case .empty:
            Text("Failed to load data.")
        }
    }
}

private extension EvolutionChainLinkRow {
    enum Constants {
        static let imageSize = 140.0
    }
    
    var evolutionChainLinkRow: some View {
        HStack {
            Group {
                if let pokemon = viewModel.pokemon {
                    ImageLoaderView(url: pokemon.officialArtWork) {
                        ProgressView()
                    } content: { image in
                        image
                            .resizable()
                            .scaledToFit()
                    }
                } else {
                    ProgressView()
                }
            }
            .frame(width: Constants.imageSize, height: Constants.imageSize)
        
            
            VStack(alignment: .leading) {
                HStack {
                    Text(viewModel.localizedPokemonName)
                    Spacer()
                    if let pokemon = viewModel.pokemon {
                        ForEach(pokemon.types, id: \.self) { pokemonType in
                            PokemonTypeTag(pokemonType: pokemonType)
                        }
                    }
                }
                
                if let evolutionDetails = chainLink.evolutionDetails, evolutionDetails.count > 1 {
                    TabView {
                        ForEach(evolutionDetails, id: \.self) { evolutionDetail in
                            EvolutionDetailRow(evolutionDetail: evolutionDetail)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .overlay(alignment: .bottomTrailing) {
                        Text("Swipe")
                            .footerStyle()
                            .foregroundColor(.gray)
                    }
                } else if let evolutionDetails = chainLink.evolutionDetails {
                    ForEach(evolutionDetails, id: \.self) { evolutionDetail in
                        EvolutionDetailRow(evolutionDetail: evolutionDetail)
                    }
                }
            }
        }
        .bodyStyle()
        .foregroundColor(.textColour)
    }
}

struct EvolutionChainLinkRow_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.backgroundColour
                .ignoresSafeArea()
            EvolutionChainLinkRow(chainLink: .example)
                .environmentObject(ImageCache())
                .environmentObject(SettingsManager())
        }
    }
}
