//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

/// The detail view for a pokemon.
struct PokemonDetail: View {
    private var pokemon: Pokemon
    @State private var selectedTab: PokmeonInfoTab = .about
    
    @StateObject private var viewModel = PokemonDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appSettings) private var appSettings
    @EnvironmentObject var settingsManager: SettingsManager
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    @Namespace private var namespace
    private let animationID = 1
    private let size = 250.0
    
    var body: some View {
        VStack {
            header
            ScrollView(showsIndicators: false) {
                VStack {
                    pokemonInfoBar
                    
                    PokemonImage(url: pokemon.officialArtWork, imageSize: size)
                    VStack {
                        tabHeader
                        switch selectedTab {
                        case .about: AboutTab(pokemon: pokemon)
                        case .stats: StatsTab(pokemon: pokemon)
                        case .evolutions: EvolutionsTab(pokemon: pokemon)
                        case .moves: MovesTab(pokemon: pokemon)
                        }
                                        
                    }
                    .padding()
                    .background {
                        Color.white
                    }
                    .clipShape(CustomRoundedRectangle(corners: [.allCorners], radius: 24))
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 5)
                }
            }
        }
        .toolbar(.hidden)
        .task {
            await viewModel.setUp(pokemon: pokemon, settings: appSettings)
        }
        .background {
            Rectangle()
                .fill(pokemon.primaryTypeColour.gradient)
                .ignoresSafeArea(edges: .top)
        }
    }
    
    func isSelected(tab: PokmeonInfoTab) -> Bool {
        selectedTab == tab
    }
}

// MARK: - Subviews
private extension PokemonDetail {
    var pokemonInfoBar: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.localizedPokemonName(language: appSettings.language))
                    .font(.largeTitle)
                    .bold()
                HStack {
                    ForEach(pokemon.types, id: \.self) { type in
                        PokemonTypeTag(name: type.type.name)
                    }
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(verbatim: "#\(String(format: "%03d", pokemon.id))")
                    .font(.title)
                Text(viewModel.pokemonSeedType)
                    .font(.title2)
            }
        }
        .foregroundColor(.textColour)
        .padding(.horizontal)
    }
    
    var header: some View {
        HeaderBar {
            dismiss()
        } content: {
            Spacer()
            Button {
                
            } label: {
                Image(systemName: "heart")
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func tabMenuButton(tab: PokmeonInfoTab) -> some View {
        Text(tab.rawValue.capitalized)
            .padding(.vertical, 2)
            .frame(maxWidth: .infinity)
            .foregroundColor(isSelected(tab: tab) ? .black : .grayTextColour)
            .background(alignment: .bottom) {
                if isSelected(tab: tab) {
                    Rectangle()
                        .fill(pokemon.primaryTypeColour)
                        .frame(height: 2)
                        .matchedGeometryEffect(id: animationID, in: namespace)
                }
            }
            .animation(.spring(), value: selectedTab)
    }
    
    var tabHeader: some View {
        HStack {
            ForEach(PokmeonInfoTab.allCases) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    tabMenuButton(tab: tab)
                        .fixedSize(horizontal: false, vertical: true)
                        .contentShape(Rectangle())
                }
            }
        }
    }
}

struct PokemonDetail_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetail(pokemon: .example)
            .environmentObject(ImageCache())
            .environmentObject(SettingsManager())
    }
}
