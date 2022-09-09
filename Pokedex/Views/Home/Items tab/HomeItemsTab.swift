//
//  ItemTab.swift
//  Pokedex
//
//  Created by Tino on 18/8/2022.
//

import SwiftUI

struct HomeItemsTab: View {
    @ObservedObject var viewModel: HomeItemsTabViewModel
    
    private let columns: [GridItem] = [
        .init(.adaptive(minimum: 400, maximum: 800))
    ]
    
    var body: some View {
        ScrollView {
            if viewModel.viewState == .loading {
                LoadingView()
            } else if viewModel.searchState == .searching && viewModel.filteredItems.isEmpty {
                LoadingView(text: "Searching for \(viewModel.searchText)")
            } else if viewModel.searchState == .error {
                SearchErrorView()
            } else {
                itemsList
            }
        }
        .task {
            if viewModel.viewState == .loading {
                await viewModel.getItems()
                viewModel.viewState = .loaded
            }
        }
        
    }
}


// MARK: - ItemCard
private extension HomeItemsTab {
    var itemsList: some View {
        LazyVGrid(columns: columns) {
            ForEach(viewModel.filteredItems) { item in
                NavigationLink(value: item) {
                    ItemCardView(item: item)
                }
            }
            if viewModel.hasNextPage && viewModel.searchState == .idle {
                ProgressView()
                    .task {
                        await viewModel.getNextItemsPage()
                    }
            }
        }
        
        .padding(.horizontal)
    }
}

struct HomeItemTab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeItemsTab(viewModel: HomeItemsTabViewModel())
                .environmentObject(ImageCache())
        }
    }
}
