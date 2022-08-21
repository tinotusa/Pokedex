//
//  AbilityListView.swift
//  Pokedex
//
//  Created by Tino on 20/8/2022.
//

import SwiftUI

struct AbilityListView: View {
    @EnvironmentObject private var viewModel: AbilityListViewViewModel
    @EnvironmentObject private var searchBar: SearchBarViewModel
    
    @State private var columns: [GridItem] = [
        .init(.adaptive(minimum: 300))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.filteredAbilities(searchText: searchBar.sanitizedSearchText)) { ability in
                    NavigationLink(destination: Text("Ability detail for \(ability.name)")) {
                        AbilityCardView(ability: ability)
                    }
                }
                if searchBar.isSearching && viewModel.hasNextPage && !viewModel.isLoading {
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
//            Text("Ability detail: \(ability.name)")
//        }
        .task {
            if !viewModel.viewHasAppeared {
                await viewModel.getAbilities()
                viewModel.viewHasAppeared = true
            }
        }
    }
}

struct AbilityListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AbilityListView()
                .environmentObject(AbilityListViewViewModel())
                .environmentObject(SearchViewViewModel())
        }
    }
}
