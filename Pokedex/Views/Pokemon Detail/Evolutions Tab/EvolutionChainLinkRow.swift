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
    @Environment(\.appSettings) var appSettings
    
    var body: some View {
        Group {
            if !viewModel.viewHasAppeared {
                ProgressView()
                    .frame(width: Constants.imageSize, height: Constants.imageSize)
            } else {
                HStack {
                    ImageLoaderView(url: viewModel.wrappedPokemon.officialArtWork) {
                        ProgressView()
                    } content: { image in
                        image
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(width: Constants.imageSize, height: Constants.imageSize)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(viewModel.localizedPokemonName)
                            Spacer()
                            ForEach(viewModel.wrappedPokemon.types, id: \.self) { pokemonType in
                                PokemonTypeTag(name: pokemonType.type.name)
                            }
                        }
                        
                        ForEach(chainLink.evolutionDetails ?? [], id: \.self) { evolutionDetail in
                            EvolutionDetailRow(evolutionDetail: evolutionDetail)
                        }
                    }
                }
            }
        }
        .bodyStyle()
        .foregroundColor(.textColour)
        .task {
            if !viewModel.viewHasAppeared {
                viewModel.setUp(chainLink: chainLink, settings: appSettings)
                await viewModel.loadData()
                viewModel.viewHasAppeared = true
            }
        }
    }
}

private extension EvolutionChainLinkRow {
    enum Constants {
        static let imageSize = 140.0
    }
}

struct EvolutionChainLinkRow_Previews: PreviewProvider {
    static var previews: some View {
        EvolutionChainLinkRow(chainLink: .example)
            .environmentObject(ImageCache())
    }
}
