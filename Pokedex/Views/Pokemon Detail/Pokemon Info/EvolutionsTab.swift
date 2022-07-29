//
//  EvolutionsTab.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

final class EvolutionsTabViewModel: ObservableObject {
    private let pokemon: Pokemon
    @Published private(set) var pokemonSpecies: PokemonSpecies?
    @Published private(set) var evolutionChain: EvolutionChain?
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    @MainActor
    func setUp() async {
        pokemonSpecies = await PokemonSpecies.from(name: pokemon.name)
        guard let evolutionChainURL = pokemonSpecies?.evolutionChain?.url else {
            return
        }
        evolutionChain = try? await PokeAPI.getData(for: EvolutionChain.self, url: evolutionChainURL)
    }
}

struct EvolutionsTab: View {
    @StateObject private var viewModel: EvolutionsTabViewModel
    
    init(pokemon: Pokemon) {
        _viewModel = StateObject(wrappedValue: EvolutionsTabViewModel(pokemon: pokemon))
    }
    
    var body: some View {
        VStack {
            ForEach(viewModel.evolutionChain?.allEvolutions() ?? [], id: \.self) { chain in
                Text(chain.species.name)
                ForEach(chain.evolutionDetails ?? [], id: \.self) { evolutionDetail in
                    if let minLevel = evolutionDetail.minLevel {
                        Text("Evolves at: \(minLevel)")
                    }
                    if let item = evolutionDetail.item {
                        Text("Evolves with: \(item.name)")
                    }
                    if let heldItem = evolutionDetail.heldItem {
                        Text("Evolves with: \(heldItem.name)")
                    }
                    if let minHappiness = evolutionDetail.minHappiness {
                        Text("Min happiness: \(minHappiness)")
                    }
                    if !evolutionDetail.timeOfDay.isEmpty {
                        Text("Time: \(evolutionDetail.timeOfDay)")
                    }
                    
                }
            }
        }
        .task {
            await viewModel.setUp()
        }
    }
}

struct EvolutionsTab_Previews: PreviewProvider {
    static var previews: some View {
        EvolutionsTab(pokemon: .example)
    }
}
