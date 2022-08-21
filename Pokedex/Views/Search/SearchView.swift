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
                    Text(viewModel.headerTitle)
                        .headerStyle()
                        .foregroundColor(.headerTextColour)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    SearchBar(placeholder: "Search")
                    SearchTabs(selectedTab: $viewModel.searchTab)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.horizontal)
                
                Group {
                    switch viewModel.searchTab {
                    case .pokemon: PokemonGridView()
                    case .items: ItemGridView()
                    case .moves: MoveGridView()
                    case .abilities: AbilityListView()
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

private extension SearchView {
    struct SearchTabs: View {
        @Binding var selectedTab: SearchViewViewModel.SearchTab
        
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(SearchViewViewModel.SearchTab.allCases) { tab in
                        Button {
                            selectedTab = tab
                        } label: {
                            tabButton(for: tab)
                        }
                    }
                    
                }
            }
        }
        
        func tabButton(for tab: SearchViewViewModel.SearchTab) -> some View {
            Text(tab.rawValue.capitalized)
                .padding(.horizontal)
                .padding(.vertical, 5)
                .foregroundColor(Color.white)
                .background(isSelectedTab(tab) ? Color.selectedTabColour : Color.unselectedTabColour)
                .cornerRadius(Constants.cornerRadius)
        }
        
        func isSelectedTab(_ currentTab: SearchViewViewModel.SearchTab) -> Bool {
            selectedTab == currentTab
        }
        enum Constants {
            static let cornerRadius = 20.0
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
