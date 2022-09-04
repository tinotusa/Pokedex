//
//  AbilityPokemonListView.swift
//  Pokedex
//
//  Created by Tino on 26/8/2022.
//

import SwiftUI
struct AbilityPokemonListView: View {
    @ObservedObject var abilityDetailViewModel: AbilityDetailViewModel
    
    @StateObject private var viewModel = AbilityPokemonListViewViewModel()

    @Environment(\.dismiss) var dismiss
    @Environment(\.appSettings) var appSettings
    
    var body: some View {
        VStack(alignment: .leading) {
            PopoverNavigationBar()
            
            if !viewModel.viewHasAppeared {
                LoadingView()
            } else {
                pokemonList
            }
        }
        .bodyStyle()
        .padding(.horizontal)
        .foregroundColor(.textColour)
        .backgroundColour()
        .task {
            if !viewModel.viewHasAppeared {
                await viewModel.getPokemonAndSpecies(from: abilityDetailViewModel.ability.pokemon)
                viewModel.viewHasAppeared = true
            }
        }
    }
}


private extension AbilityPokemonListView {
    enum Constants {
        static let imageSize = 50.0
    }
    
    var pokemonList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                
                HeaderWithID(
                    title: abilityDetailViewModel.localizedAbilityName,
                    id: abilityDetailViewModel.ability.id
                )
                
                Text("Pokémon that could potentially have this ability.")
                
                Divider()
                
                ForEach(viewModel.pokemon) { pokemon in
                    HStack {
                        ImageLoaderView(url: pokemon.officialArtWork) {
                            ProgressView()
                        } content: { image in
                            image
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(width: Constants.imageSize, height: Constants.imageSize)
                        if let pokemonSpecies = viewModel.pokemonSpecies(named: pokemon.species.name) {
                            Text(
                                pokemonSpecies.names.localizedName(
                                    language: appSettings.language,
                                    default: pokemonSpecies.name)
                            )
                            Spacer()
                            Text("\(String(format: "#%03d", pokemonSpecies.id))")
                                .foregroundColor(.gray)
                        }
                    }
                }
                if viewModel.hasNextPage {
                    ProgressView()
                        .task {
                            await viewModel.getNextPokemonAndSpeciesPage(abilityPokemonArray: abilityDetailViewModel.ability.pokemon)
                        }
                        .onDisappear {
                            print("disappeared \(viewModel.hasNextPage)")
                        }
                }
            }
            
        }
    }
}

struct AbilityPokemonListView_Previews: PreviewProvider {
    static var viewModel = {
        let vm = AbilityDetailViewModel()
        vm.setUp(ability: .example, settings: .default)
        vm.setGeneration(generation: .example)
        
        return vm
    }()
    
    static var previews: some View {
        AbilityPokemonListView(abilityDetailViewModel: viewModel)
            .environmentObject(ImageCache())
    }
}
