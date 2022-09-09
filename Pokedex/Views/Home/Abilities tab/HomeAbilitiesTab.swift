//
//  HomeAbilitiesTab.swift
//  Pokedex
//
//  Created by Tino on 20/8/2022.
//

import SwiftUI

struct HomeAbilitiesTab: View {
    @ObservedObject var viewModel: HomeAbilitiesTabViewModel
    
    @State private var columns: [GridItem] = [
        .init(.adaptive(minimum: 300))
    ]
    
    var body: some View {
        ScrollView {
            if viewModel.viewLoadingState == .loading {
                LoadingView()
            } else if viewModel.searchState == .searching && viewModel.filteredAbilities.isEmpty {
                LoadingView(text: "Searching")
            } else if viewModel.searchState == .error {
                SearchErrorView()
            } else {
                abilitiesList
            }
        }
        .task {
            if viewModel.viewLoadingState == .loading {
                await viewModel.getAbilities()
                viewModel.viewLoadingState = .loaded
            }
        }
    }
}

private extension HomeAbilitiesTab {
    var abilitiesList: some View {
        LazyVGrid(columns: columns) {
            ForEach(viewModel.filteredAbilities) { ability in
                NavigationLink(value: ability) {
                    AbilityCardView(ability: ability)
                }
            }
            if viewModel.hasNextPage && viewModel.searchState == .idle {
                ProgressView()
                    .task {
                        print("progress view showed")
                        await viewModel.getNextAbilitesPage()
                    }
            }
        }
        .padding(.horizontal)
    }
}

struct HomeAbilitiesTab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ZStack {
                Color.backgroundColour
                    .ignoresSafeArea()
                HomeAbilitiesTab(viewModel: HomeAbilitiesTabViewModel())
                    .environmentObject(HomeAbilitiesTabViewModel())
            }
        }
    }
}
