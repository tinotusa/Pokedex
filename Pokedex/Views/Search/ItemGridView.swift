//
//  ItemGridView.swift
//  Pokedex
//
//  Created by Tino on 18/8/2022.
//

import SwiftUI

struct ItemGridView: View {
    @Binding private var searchSubmitted: Bool
    @StateObject private var viewModel = ItemGridViewViewModel()
    @Environment(\.searchText) var searchText
    
    init(searchSubmitted: Binding<Bool>) {
        _searchSubmitted = searchSubmitted
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.filteredItems(searchText: searchText)) { item in
                    Text(item.name)
                }
                if viewModel.hasNextPage && !isSearching {
                    ProgressView()
                        .task {
                            await viewModel.getNextItemsPage()
                        }
                }
            }
        }
        .task {
            await viewModel.getItems()
        }
        .onChange(of: searchSubmitted) { searchSubmitted in
            defer { self.searchSubmitted = false }
            if !searchSubmitted { return }
            Task {
                await viewModel.getItem(searchText: searchText)
            }
        }
    }
}

private extension ItemGridView {
    var isSearching: Bool {
        !searchText.isEmpty
    }
}

struct ItemGridView_Previews: PreviewProvider {
    static var previews: some View {
        ItemGridView(searchSubmitted: .constant(false))
    }
}
