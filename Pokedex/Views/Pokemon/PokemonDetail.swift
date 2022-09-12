//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

/// The detail view for a pokemon.
struct PokemonDetail: View {
    let pokemon: Pokemon
    @State private var selectedTab: PokemonInfoTab = .about
    
    @StateObject private var viewModel = PokemonDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var settingsManager: SettingsManager
    
    // MARK: Tab view models
    @StateObject private var pokemonAboutTabViewModel = PokemonAboutTabViewModel()
    @StateObject private var pokemonStatsTabViewModel = PokemonStatsTabViewModel()
    @StateObject private var pokemonEvolutionsTabViewModel = PokemonEvolutionsTabViewModel()
    @StateObject private var pokemonMovesTabViewModel = PokemonMovesTabViewModel()
    
    var body: some View {
        VStack {
            header
            ScrollView(showsIndicators: false) {
                VStack {
                    switch viewModel.viewState {
                    case .loading:
                        LoadingView()
                            .task {
                                await viewModel.load(pokemon: pokemon, settings: settingsManager.settings)
                            }
                    case .loaded:
                        VStack {
                            PokemonImage(url: pokemon.officialArtWork, imageSize: Constants.imageSize)
                            
                            TabBar(tabs: PokemonInfoTab.self, selectedTab: $selectedTab)
                            
                            switch selectedTab {
                            case .about: PokemonAboutTab(pokemon: pokemon, viewModel: pokemonAboutTabViewModel)
                            case .stats: PokemonStatsTab(pokemon: pokemon, viewModel: pokemonStatsTabViewModel)
                            case .evolutions: PokemonEvolutionsTab(pokemon: pokemon, viewModel: pokemonEvolutionsTabViewModel)
                            case .moves: PokemonMovesTab(pokemon: pokemon, viewModel: pokemonMovesTabViewModel)
                            }
                        }
                    default:
                        Text("Error loading")
                    }
                }
            }
        }
        .toolbar(.hidden)
        .bodyStyle()
        .foregroundColor(.textColour)
        .padding(.horizontal)
        .backgroundColour()
    }
}

// MARK: - Subviews
private extension PokemonDetail {
    var header: some View {
        HeaderBar {
            Button {
                
            } label: {
                Image(systemName: "heart")
            }
        }
    }
    
    func isSelected(tab: PokemonInfoTab) -> Bool {
        selectedTab == tab
    }
    
    enum Constants {
        static let imageSize = 250.0
    }
}

struct PokemonDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PokemonDetail(pokemon: .example)
                .environmentObject(ImageCache())
                .environmentObject(SettingsManager())
        }
    }
}
