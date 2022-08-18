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
                Group {
                    Text(viewModel.headerTitle)
                        .headerStyle()
                        .foregroundColor(.headerTextColour)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    SearchBar(placeholder: "Search", text: $viewModel.searchText) {
                        viewModel.searchSubmitted = true
                    }
                    SearchTabs(selectedTab: $viewModel.searchTab)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.horizontal)
                
                TabView(selection: $viewModel.searchTab) {
                    PokemonGridView(searchSubmitted: $viewModel.searchSubmitted)
                        .tag(SearchViewViewModel.SearchTab.pokemon)
                    ItemGridView(searchSubmitted: $viewModel.searchSubmitted)
                        .tag(SearchViewViewModel.SearchTab.items)
                    Text("Moves search")
                        .tag(SearchViewViewModel.SearchTab.moves)
                    Text("Abilities search")
                        .tag(SearchViewViewModel.SearchTab.abilities)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()
                .setSearchText(
                    viewModel.searchText
                        .lowercased()
                        .replacingOccurrences(of: " ", with: "-")
                )
                
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
            .environmentObject(ImageLoader())
        
    }
}
