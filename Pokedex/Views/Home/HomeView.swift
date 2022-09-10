//
//  HomeView.swift
//  Pokedex
//
//  Created by Tino on 3/8/2022.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewViewModel()
    @State private var navigationPath = NavigationPath()
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.appSettings) var appSettings
    
    // MARK: - Tab view models
    @StateObject var homePokemonTabViewModel = HomePokemonTabViewModel()
    @StateObject var homeItemsTabViewModel = HomeItemsTabViewModel()
    @StateObject var homeMovesTabViewModel = HomeMovesTabViewModel()
    @StateObject var homeAbilitiesTabViewModel = HomeAbilitiesTabViewModel()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 20) {
                Group {
                    VStack(spacing: 0) {
                        Text(viewModel.headerTitle)
                            .headerStyle()
                            .foregroundColor(.headerTextColour)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        SearchBar(placeholder: "Search", searchText: $viewModel.searchText)
                    }
                    TabBar(tabs: HomeViewViewModel.SearchTab.self, selectedTab: $viewModel.searchTab)
                }
                .padding(.horizontal)
                
                switch viewModel.searchTab {
                case .pokemon: HomePokemonTab(viewModel: homePokemonTabViewModel)
                case .items: HomeItemsTab(viewModel: homeItemsTabViewModel)
                case .moves: HomeMovesTab(viewModel: homeMovesTabViewModel)
                case .abilities: HomeAbilitiesTab(viewModel: homeAbilitiesTabViewModel)
                }
                
                Spacer()
            }
            // TODO: This seems wrong because they are not near the corresponding navigation  link
            // but this is the only way it works.
            .navigationDestination(for: Pokemon.self) { pokemon in
                PokemonDetail(pokemon: pokemon)
            }
            .navigationDestination(for: Item.self) { item in
                ItemDetail(item: item)
            }
            .navigationDestination(for: Move.self) { move in
                MoveDetail(move: move)
            }
            .navigationDestination(for: Ability.self) { ability in
                AbilityDetail(ability: ability)
            }
            .navigationDestination(for: `Type`.self) { type in
                Text("Looking at: \(type.name)")
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
            .onReceive(
                viewModel.$searchText
                    .dropFirst()
                    .debounce(for: .seconds(0.8), scheduler: RunLoop.main)
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines)
                        .lowercased()
                        .replacingOccurrences(of: " ", with: "-")
                    }
            ) { searchText in
                Task {
                    print("Search text: \(searchText)")
                    switch viewModel.searchTab {
                    case .pokemon: homePokemonTabViewModel.searchText = searchText
                    case .items: homeItemsTabViewModel.searchText = searchText
                    case .moves: homeMovesTabViewModel.searchText = searchText
                    case .abilities: homeAbilitiesTabViewModel.searchText = searchText
                    }
                }
            }
        }
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ImageCache())
    }
}
