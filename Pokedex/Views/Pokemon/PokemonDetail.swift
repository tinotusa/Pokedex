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
    private let pokemon: Pokemon
    @State private var selectedTab: InfoTab = .about
    @StateObject private var viewModel: PokemonDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var pokeAPI: PokeAPI
    
    @Namespace private var namespace
    private let animationID = 1
    private let size = 250.0
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        _viewModel = StateObject(wrappedValue: PokemonDetailViewModel(pokemon: pokemon))
    }
    
    var body: some View {
        VStack {
            header
            
            ScrollView(showsIndicators: false) {
                pokemonInfoBar
                    .padding(.horizontal)
                pokemonImage
                VStack {
                    tabHeader
                        .padding(.vertical)
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
                        .ignoresSafeArea()
                }
                .clipShape(CustomRoundedRectangle(corners: [.allCorners], radius: 24))
                .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 5)
            }
            .task {
                await viewModel.setUp(pokeAPI: pokeAPI)
            }
            .toolbar(.hidden)
        }
        .background {
            Rectangle()
                .fill(viewModel.pokemonTypeColour.gradient)
                .ignoresSafeArea()
        }
    }
    
    func isSelected(tab: InfoTab) -> Bool {
        selectedTab == tab
    }
}

// MARK: - Subviews
private extension PokemonDetail {
    @ViewBuilder
    func tabMenuButton(tab: InfoTab) -> some View {
        Text(tab.rawValue.capitalized)
            .padding(.vertical, 2)
            .frame(maxWidth: .infinity)
            .foregroundColor(isSelected(tab: tab) ? .black : .grayTextColour)
            .background(alignment: .bottom) {
                if isSelected(tab: tab) {
                    Rectangle()
                        .fill(viewModel.pokemonTypeColour)
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
    
    var pokemonImage: some View {
        AsyncImage(url: viewModel.pokemonImageURL) { image in
            image
                .resizable()
                .frame(width: size, height: size)
                .scaledToFit()
        } placeholder: {
            ZStack {
                viewModel.pokemonTypeColour
                    .opacity(0.7)
                    .frame(width: size, height: size)
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
    }
    
    @ViewBuilder
    var pokemonInfoBar: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(viewModel.pokemonName)
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Text("#\(viewModel.pokemonID)")
                    .font(.title)
                    .bold()
            }
            HStack {
                ForEach(viewModel.pokemonTypes) { type in
                    PokemonTypeTag(name: type.type.name)
                }
                Spacer()
                Text(viewModel.eggGroupNames)
            }
        }
        .foregroundColor(.textColour)
    }
    
    var header: some View {
        HeaderBar {
            dismiss()
        } content: {
            Text(viewModel.pokemonName)
                .foregroundColor(.textColour)
            Spacer()
            Button {
                // TODO: - might implement later.
            } label: {
                Image(systemName: "heart")
            }
        }
        .padding(.horizontal)
    }
}

struct PokemonDetail_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetail(pokemon: .example)
            .environmentObject(PokeAPI())
    }
}
