//
//  AbilityTab.swift
//  Pokedex
//
//  Created by Tino on 20/8/2022.
//

import SwiftUI

struct AbilityTab: View {
    @EnvironmentObject private var viewModel: AbilityListViewViewModel
    @EnvironmentObject private var searchBar: SearchBarViewModel
    
    @State private var columns: [GridItem] = [
        .init(.adaptive(minimum: 300))
    ]
    
    var body: some View {
        Group {
            if !viewModel.viewHasAppeared {
                LoadingView()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.filteredAbilities(searchText: searchBar.sanitizedSearchText)) { ability in
                            NavigationLink {
                                AbilityDetail(ability: ability)
                            } label: {
                                AbilityCardView(ability: ability)
                            }
                        }
                        if viewModel.hasNextPage && !searchBar.isSearching {
                            ProgressView()
                                .task {
                                    print("progress view showed")
                                    await viewModel.getNextAbilitesPage()
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                //        .navigationDestination(for: Ability.self) { ability in
                //            AbilityDetail(ability: ability)
                //        }
            }
        }
        .task {
            if !viewModel.viewHasAppeared {
                await viewModel.getAbilities()
                viewModel.viewHasAppeared = true
            }
        }
    }
}

struct AbilityTab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ZStack {
                Color.backgroundColour
                    .ignoresSafeArea()
                AbilityTab()
                    .environmentObject(AbilityListViewViewModel())
                    .environmentObject(SearchBarViewModel())
            }
        }
    }
}
