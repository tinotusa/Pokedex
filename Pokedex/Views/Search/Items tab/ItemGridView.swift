//
//  ItemGridView.swift
//  Pokedex
//
//  Created by Tino on 18/8/2022.
//

import SwiftUI

struct ItemGridView: View {
    @EnvironmentObject private var viewModel: ItemGridViewViewModel
    @EnvironmentObject private var searchBar: SearchBarViewModel
    
    private let columns: [GridItem] = [
        .init(.adaptive(minimum: 400, maximum: 800))
    ]
    
    var body: some View {
        Group {
            if viewModel.items.isEmpty && viewModel.isLoading {
                LoadingView()
            } else {
                itemsList
            }
        }
        .task {
            if !viewModel.viewHasApeared {
                await viewModel.getItems()
                viewModel.viewHasApeared = true
            }
        }
//        .navigationDestination(for: Item.self) { item in
//            Text("item view: for \(item.name)")
//        }
        .onReceive(
            searchBar.$searchText
                .debounce(
                    for: 0.8,
                    scheduler: RunLoop.main
                )
        ) { searchText in
            Task {
                await viewModel.getItem(searchText: searchText)
            }
        }
    }
}


// MARK: - ItemCard
private extension ItemGridView {
    var itemsList: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.filteredItems(searchText: searchBar.sanitizedSearchText)) { item in
                    NavigationLink(destination: Text("Item detail view for: \(item.name)")) {
                        ItemCardView(item: item)
                    }
                    .buttonStyle(.plain)
                }
                if viewModel.hasNextPage && !searchBar.isSearching {
                    ProgressView()
                        .task {
                            await viewModel.getNextItemsPage()
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ItemGridView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ItemGridView()
                .environmentObject(ImageCache())
                .environmentObject(ItemGridViewViewModel())
                .environmentObject(SearchBarViewModel())
        }
    }
}
