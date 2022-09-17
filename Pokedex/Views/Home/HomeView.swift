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
    
    // MARK: - Tab view models
    @StateObject var homePokemonTabViewModel = HomePokemonTabViewModel()
    @StateObject var homeItemsTabViewModel = HomeItemsTabViewModel()
    @StateObject var homeMovesTabViewModel = HomeMovesTabViewModel()
    @StateObject var homeAbilitiesTabViewModel = HomeAbilitiesTabViewModel()
    
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 20) {
                Group {
                    VStack(spacing: 0) {
                        HStack {
                            Text(viewModel.headerTitle)
                                .headerStyle()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Button(action: showSettingsView) {
                                Image(systemName: "gearshape.fill")
                                    .subHeaderStyle()
                            }
                        }
                        
                        .foregroundColor(.headerTextColour)
                        
                        SearchBar(placeholder: viewModel.searchPlaceholder, searchText: $viewModel.searchText)
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
            .popover(isPresented: $viewModel.showSettingsView) {
                SettingsView()
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
                    .preferredColorScheme(settingsManager.isDarkMode ? .dark : .light)
            }
            // TODO: This seems wrong because they are not near the corresponding navigation  link
            // but this is the only way it works.
//            .navigationDestination(for: Pokemon.self) { pokemon in
//                PokemonDetail(pokemon: pokemon)
//            }
//            .navigationDestination(for: Item.self) { item in
//                ItemDetail(item: item)
//            }
//            .navigationDestination(for: Move.self) { move in
//                MoveDetail(move: move)
//            }
//            .navigationDestination(for: Ability.self) { ability in
//                AbilityDetail(ability: ability)
//            }
//            .navigationDestination(for: `Type`.self) { type in
//                TypeDetail(type: type)
//            }
//            .navigationDestination(for: Generation.self) { generation in
//                Text("Looking at: \(generation.name)")
//            }
//            .navigationDestination(for: MoveDamageClass.self) { damageClass in
//                Text("Looking at: \(damageClass.name)")
//            }
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

private extension HomeView {
    func showSettingsView() {
        viewModel.showSettingsView = true
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ImageCache())
            .environmentObject(SettingsManager())
    }
}
