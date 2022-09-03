//
//  PokemonEvolutionsTab.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

struct PokemonEvolutionsTab: View {
    let pokemon: Pokemon
    @StateObject private var viewModel = EvolutionsTabViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(viewModel.evolutionChainLinks, id: \.self) { chainLink in
                EvolutionChainLinkRow(chainLink: chainLink)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .task {
            if !viewModel.viewHasAppeared {
                viewModel.setUp(pokemon: pokemon)
                await viewModel.loadData()
                viewModel.getAllChains()
                viewModel.viewHasAppeared = true
            }
        }
    }
}

struct EvolutionsTab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PokemonEvolutionsTab(pokemon: .example)
                .environmentObject(ImageCache())
        }
    }
}
