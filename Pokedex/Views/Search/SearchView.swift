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

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(viewModel.headerTitle)
                        .headerStyle()
                        .foregroundColor(.headerTextColour)
                    SearchBar(placeholder: "Search", text: $viewModel.searchText) {
                        viewModel.searchSubmitted = true
                    }
                }
                .padding(.horizontal)
                
                SearchTabs(selectedTab: $viewModel.searchTab)
                    .padding(.horizontal)
                
                Group {
                    switch viewModel.searchTab {
                    case .pokemon: PokemonGridView(searchSubmitted: $viewModel.searchSubmitted)
                    case .items: ItemGridView(searchSubmitted: $viewModel.searchSubmitted)
                    case .moves: Text("Moves search")
                    case .abilities: Text("Abilities search")
                    }
                }
                .setSearchText(viewModel.searchText)
                Spacer()
            }
            .ignoresSafeArea(edges: .bottom)
            .background {
                ZStack {
                    Color.backgroundColour
                    Circle()
                        .fill(Color.backgroundCircleColour)
                        .frame(width: 650, height: 650)
                        .offset(y: -650 + 150)
                }
            }
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
        
        private func tabButton(for tab: SearchViewViewModel.SearchTab) -> some View {
            Text(tab.rawValue.capitalized)
                .padding(.horizontal)
                .padding(.vertical, 5)
                .foregroundColor(Color.white)
                .background(isSelectedTab(tab) ? Color.selectedTabColour : Color.unselectedTabColour)
                .cornerRadius(Constants.cornerRadius)
        }
        
        private func isSelectedTab(_ currentTab: SearchViewViewModel.SearchTab) -> Bool {
            selectedTab == currentTab
        }
        
        private enum Constants {
            static let cornerRadius = 20.0
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(ImageLoader())
        
    }
}
