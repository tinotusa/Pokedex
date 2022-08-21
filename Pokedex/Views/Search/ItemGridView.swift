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
        .init(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        Group {
            if viewModel.items.isEmpty || viewModel.isLoading {
                loadingView
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
extension ItemGridView {
    var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
    
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
    
    struct ItemCardView: View {
        let item: Item
        
        var body: some View {
            VStack {
                ImageLoaderView(url: item.sprites.default) {
                    ProgressView()
                } content: { image in
                    image
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: Constants.imageSize, height: Constants.imageSize)
                
                VStack(alignment: .leading) {
                    Text(item.names.localizedName(default: item.name))
                    HStack{
                        if item.cost == 0 {
                            Text("Quest item")
                        } else {
                            Text("Cost")
                            Spacer()
                            Text("\(item.cost)")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .bodyStyle()
                .foregroundColor(.textColour)
            }
            .padding()
            .background(Color.cardBackgroundColour)
            .cornerRadius(Constants.cornerRadius)
            .shadow(radius: 3)
        }
        
        enum Constants {
            static let imageSize = 100.0
            static let cornerRadius = 20.0
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
