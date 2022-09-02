//
//  SearchView.swift
//  Pokedex
//
//  Created by Tino on 3/8/2022.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewViewModel()
    @State private var navigationPath = NavigationPath()
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.appSettings) var appSettings
    @EnvironmentObject private var pokemonGridViewViewModel: PokemonGridViewViewModel
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 20) {
                Group {
                    VStack(spacing: 0) {
                        Text(viewModel.headerTitle)
                            .headerStyle()
                            .foregroundColor(.headerTextColour)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        SearchBar(placeholder: "Search")
                    }
                    TabBar(tabs: SearchViewViewModel.SearchTab.self, selectedTab: $viewModel.searchTab)
                }
                .padding(.horizontal)
                
                Group {
                    switch viewModel.searchTab {
                    case .pokemon: PokemonTab()
                    case .items: ItemTab()
                    case .moves: MoveTab()
                    case .abilities: AbilityTab()
                    }
                }
                .ignoresSafeArea()
                
                
                Spacer()
            }
            .ignoresSafeArea(edges: .bottom)
            .scrollDismissesKeyboard(.immediately)
            .background {
                ZStack {
                    Color.backgroundColour
                        .ignoresSafeArea()
                    Circle()
                        .fill(Color.backgroundCircleColour)
                        .frame(width: 650, height: 650)
                        .offset(y: -650 + 150)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .onAppear {
            viewModel.searchTab = .pokemon
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(ImageCache())
            .environmentObject(PokemonGridViewViewModel())
            .environmentObject(ItemGridViewViewModel())
            .environmentObject(MoveGridViewViewModel())
            .environmentObject(AbilityListViewViewModel())
            .environmentObject(SearchBarViewModel())
        
    }
}
