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
    @Environment(\.appSettings) private var appSettings
    
    var body: some View {
        VStack {
            header
            ScrollView(showsIndicators: false) {
                VStack {
                    PokemonImage(url: pokemon.officialArtWork, imageSize: Constants.imageSize)
                    
                    pokemonNameRow
                       
                    TabBar(tabs: PokemonInfoTab.self, selectedTab: $selectedTab)
                    
                    switch selectedTab {
                    case .about: AboutTab(pokemon: pokemon)
                    case .stats: StatsTab(pokemon: pokemon)
                    case .evolutions: EvolutionsTab(pokemon: pokemon)
                    case .moves: MovesTab(pokemon: pokemon)
                    }
                }
            }
        }
        .toolbar(.hidden)
        .padding(.horizontal)
        .background {
            Color.backgroundColour
        }
        .task {
            await viewModel.setUp(pokemon: pokemon, settings: appSettings)
        }
    }
}

// MARK: - Subviews
private extension PokemonDetail {
    @ViewBuilder
    var pokemonNameRow: some View {
        HStack {
            Text(viewModel.localizedPokemonName(language: appSettings.language))
            Spacer()
            Text("#\(String(format: "%03d", viewModel.pokemonID ?? 0))")
        }
        .headerStyle()
    }
    
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
        }
    }
}
