//
//  EvolutionChainCardView.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import SwiftUI

struct EvolutionChainCardView: View {
    let chain: ChainLink
    let size = 170.0
    @StateObject var viewModel: EvolutionChainViewViewModel
    
    init(chain: ChainLink) {
        self.chain = chain
        _viewModel = StateObject(wrappedValue: EvolutionChainViewViewModel(chainLink: chain))
    }
    
    var body: some View {
        NavigationLink(value: viewModel.pokemon) {
            VStack {
                HStack {
                    Text(viewModel.localizedPokemonName)
                    if let pokemon = viewModel.pokemon {
                        Text("(#\(pokemon.id))")
                    }
                }
                HStack{
                    AsyncImage(url: viewModel.pokemonImageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: size, height: size)
                    } placeholder: {
                        ProgressView()
                            .frame(width: size, height: size)
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.chainLink.evolutionDetails ?? [], id: \.self) { evolutionDetail in
                                EvolutionRequirementsSidebarView(evolutionDetail: evolutionDetail)
                            }
                        }
                    }
                }
                HStack {
                    ForEach(viewModel.pokemon?.types ?? [], id: \.self) { type in
                        PokemonTypeTag(name: type.type.name)
                    }
                }
            }
            .padding()
            .background(.white)
            .cornerRadius(24)
            .shadow(
                color: .black.opacity(0.6),
                radius: 5,
                x: 0,
                y: 6
            )
        }
        .buttonStyle(.plain)
        .task {
            await viewModel.setUp()
        }
    }
}

struct EvolutionChainCardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EvolutionChainCardView(chain: .example)
        }
    }
}
