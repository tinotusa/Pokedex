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
                       
                    TabBar(tabs: PokemonInfoTab.self, selectedTab: $selectedTab)
                    
                    switch selectedTab {
                    case .about: PokemonAboutTab(pokemon: pokemon)
                    case .stats: PokemonStatsTab(pokemon: pokemon)
                    case .evolutions: PokemonEvolutionsTab(pokemon: pokemon)
                    case .moves: PokemonMovesTab(pokemon: pokemon)
                    }
                }
            }
        }
        .toolbar(.hidden)
        .padding(.horizontal)
        .background {
            Color.backgroundColour
                .ignoresSafeArea()
        }
        .task {
            await viewModel.setUp(pokemon: pokemon, settings: appSettings)
        }
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
        }
    }
}
