//
//  PokemonEvolutionsTab.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

struct PokemonEvolutionsTab: View {
    let pokemon: Pokemon
    @StateObject private var viewModel = PokemonEvolutionsTabViewModel()
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                LoadingView()
                    .task {
                        await viewModel.loadData(pokemon: pokemon)
                    }
            case .loaded:
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(viewModel.evolutionChainLinks, id: \.self) { chainLink in
                        EvolutionChainLinkRow(chainLink: chainLink)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            case .error(let error):
                Text(error.localizedDescription)
            case .empty:
                Text("No data loaded.")
            }
        }
    }
}

struct PokemonEvolutionsTab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PokemonEvolutionsTab(pokemon: .example)
                .environmentObject(ImageCache())
        }
    }
}
