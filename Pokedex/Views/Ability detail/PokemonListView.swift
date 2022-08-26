//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Tino on 26/8/2022.
//

import SwiftUI

struct PokemonListView: View {
    @ObservedObject var abilityDetailViewModel: AbilityDetailViewModel
    
    @StateObject private var viewModel = PokemonListViewViewModel()
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.appSettings) var appSettings
    
    var body: some View {
        VStack(alignment: .leading) {
            navigationBar
            
            if viewModel.isLoading {
                LoadingView()
                    .frame(maxWidth: .infinity)
            } else {
                pokemonList
            }
        }
        .bodyStyle()
        .foregroundColor(.textColour)
        .padding(.horizontal)
        .task {
            await viewModel.loadData(from: abilityDetailViewModel.ability.pokemon)
        }
    }
}


private extension PokemonListView {
    enum Constants {
        static let imageSize = 50.0
    }
    
    var navigationBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Label("Close", systemImage: "xmark")
            }
        }
    }
    
    var titleAndIDRow: some View {
        VStack(spacing: 0) {
            HStack {
                Text(abilityDetailViewModel.localizedAbilityName)
                Spacer()
                Text(abilityDetailViewModel.abilityID)
                    .fontWeight(.ultraLight)
            }
            .headerStyle()
            
            Divider()
        }
    }
    
    var pokemonList: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                
                titleAndIDRow
                
                Text("Pokémon that could potentially have this ability.")
                
                Divider()
                
                ForEach(Array(viewModel.filteredPokemon)) { pokemon in
                    HStack {
                        ImageLoaderView(url: pokemon.officialArtWork) {
                            ProgressView()
                        } content: { image in
                            image
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(width: Constants.imageSize)
                        
                        if let pokemonSpecies = viewModel.pokemonSpecies(name: pokemon.species.name) {
                            Text(pokemonSpecies.names.localizedName(language: appSettings.language, default: pokemonSpecies.name))
                            Spacer()
                            Text("\(String(format: "#%03d", pokemonSpecies.id))")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            
        }
    }
}

struct AbilityDetail_PokemonListView_Previews: PreviewProvider {
    static var viewModel = {
        let vm = AbilityDetailViewModel()
        vm.setUp(ability: .example, settings: .default)
        vm.setGeneration(generation: .example)
        
        return vm
    }()
    
    static var previews: some View {
        PokemonListView(abilityDetailViewModel: viewModel)
            .environmentObject(ImageCache())
    }
}
