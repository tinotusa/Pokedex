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
    
    init(chain: ChainLink, pokemon: Pokemon) {
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
                    PokemonImage(url: viewModel.pokemonImageURL, imageSize: size)
                        .id(UUID())
                    if let evolutionDetails = viewModel.chainLink.evolutionDetails, !evolutionDetails.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.chainLink.evolutionDetails ?? [], id: \.self) { evolutionDetail in
                                    EvolutionRequirementsSidebarView(evolutionDetail: evolutionDetail)
                                        
                                }
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
            .frame(maxWidth: .infinity)
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
    }
}

struct EvolutionChainCardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EvolutionChainCardView(chain: .example, pokemon: .example)
        }
    }
}
