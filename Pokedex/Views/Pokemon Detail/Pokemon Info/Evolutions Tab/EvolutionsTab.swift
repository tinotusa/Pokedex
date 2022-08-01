//
//  EvolutionsTab.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

struct EvolutionsTab: View {
    private let pokemon: Pokemon
    @StateObject private var viewModel: EvolutionsTabViewModel
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        _viewModel = StateObject(wrappedValue: EvolutionsTabViewModel(pokemon: pokemon))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let evolutionChain = viewModel.evolutionChain {
                ForEach(evolutionChain.allEvolutions(), id: \.self) { chain in
                    EvolutionChainCardView(chain: chain, pokemon: pokemon)
                }
            } else {
                Text(
                    "This Pokemon has no evolutions.",
                    comment: "Placeholder text to show that this pokemon cannot evolve into another one."
                )
                .foregroundColor(.secondary)
            }
        }
        .task {
            await viewModel.setUp()
        }
    }
}

struct EvolutionsTab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EvolutionsTab(pokemon: .example)
        }
    }
}
