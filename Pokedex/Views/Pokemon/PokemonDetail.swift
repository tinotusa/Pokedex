//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

enum InfoTab: String, CaseIterable, Identifiable {
    case about
    case stats
    case evolutions
    case moves
    
    var id: Self { self }
}

/// The detail view for a pokemon.
struct PokemonDetail: View {
    @State private var selectedTab: InfoTab = .about
    @StateObject private var viewModel: PokemonDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @Namespace private var namespace
    private let animationID = 1
    private let size = 250.0
    
    init(pokemon: Pokemon) {
        _viewModel = StateObject(wrappedValue: PokemonDetailViewModel(pokemon: pokemon))
    }
    
    var body: some View {
        VStack {
            header
            ScrollView(showsIndicators: false) {
                VStack {
                    pokemonInfoBar
                    
                    PokemonImage(url: viewModel.pokemon.officialArtWork, imageSize: size)
                    VStack {
                        tabHeader
//                        if selectedTab == .about {
//                            AboutTab(pokemon: viewModel.pokemon)
//                        } else if selectedTab == .stats {
//                            StatsTab(pokemon: viewModel.pokemon)
//                        } else if selectedTab == .evolutions {
//                            EvolutionsTab(pokemon: viewModel.pokemon)
//                        } else if selectedTab == .moves {
//                            MovesTab(pokemon: viewModel.pokemon)
//                        }
                        // TODO: This crashes when you click nav links in the views
                        switch selectedTab {
                        case .about: AboutTab(pokemon: viewModel.pokemon)
                        case .stats: StatsTab(pokemon: viewModel.pokemon)
                        case .evolutions: EvolutionsTab(pokemon: viewModel.pokemon)
                        case .moves: MovesTab(pokemon: viewModel.pokemon)
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
        .background {
            Rectangle()
                .fill(viewModel.pokemon.primaryTypeColour.gradient)
                .ignoresSafeArea(edges: .top)
        }
    }
    
    func isSelected(tab: InfoTab) -> Bool {
        selectedTab == tab
    }
}

// MARK: - Subviews
private extension PokemonDetail {
    var pokemonInfoBar: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.localizedPokemonName)
                    .font(.largeTitle)
                    .bold()
                HStack {
                    ForEach(viewModel.pokemon.types, id: \.self) { type in
                        PokemonTypeTag(name: type.type.name)
                    }
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(verbatim: "#\(String(format: "%03d", viewModel.pokemon.id))")
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
    func tabMenuButton(tab: InfoTab) -> some View {
        Text(tab.rawValue.capitalized)
            .padding(.vertical, 2)
            .frame(maxWidth: .infinity)
            .foregroundColor(isSelected(tab: tab) ? .black : .grayTextColour)
            .background(alignment: .bottom) {
                if isSelected(tab: tab) {
                    Rectangle()
                        .fill(viewModel.pokemon.primaryTypeColour)
                        .frame(height: 2)
                        .matchedGeometryEffect(id: animationID, in: namespace)
                }
            }
            .animation(.spring(), value: selectedTab)
    }
    
    var tabHeader: some View {
        HStack {
            ForEach(InfoTab.allCases) { tab in
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
            .environmentObject(ImageLoader())
    }
}
