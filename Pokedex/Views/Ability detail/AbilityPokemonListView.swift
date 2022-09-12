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
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        VStack(alignment: .leading) {
            PopoverNavigationBar()
            
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading) {
                    if let ability = abilityDetailViewModel.ability {
                        HeaderWithID(
                            title: abilityDetailViewModel.localizedAbilityName,
                            id: ability.id
                        )
                    }
                    
                    Text("Pokémon that could potentially have this ability.")
                    
                    Divider()
                    
                    switch viewModel.viewState {
                    case .loading:
                        LoadingView()
                            .task {
                                await viewModel.getPokemonAndSpecies(from: abilityDetailViewModel.ability?.pokemon)
                            }
                    case .loaded:
                        pokemonList
                    default: Text("Not possible")
                    }
                }
                
            }
        }
        .bodyStyle()
        .padding(.horizontal)
        .foregroundColor(.textColour)
        .backgroundColour()
    }
}


private extension AbilityPokemonListView {
    enum Constants {
        static let imageSize = 50.0
    }
    
    @ViewBuilder
    var pokemonList: some View {
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
                            language: settingsManager.language,
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
                    await viewModel.getNextPokemonAndSpeciesPage(abilityPokemonArray: abilityDetailViewModel.ability?.pokemon)
                }
                .onDisappear {
                    print("disappeared \(viewModel.hasNextPage)")
                }
        }
    
    }
}

struct AbilityPokemonListView_Previews: PreviewProvider {
    static var viewModel = {
        let vm = AbilityDetailViewModel()
        vm.setGeneration(generation: .example)
        Task {
            await vm.loadData(ability: .example, settings: .default)
        }
        return vm
    }()
    
    static var previews: some View {
        AbilityPokemonListView(abilityDetailViewModel: viewModel)
            .environmentObject(ImageCache())
            .environmentObject(SettingsManager())
    }
}
