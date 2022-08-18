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

    private let columns: [GridItem] = [
        .init(.adaptive(minimum: 150))
    ]
    
    init(searchSubmitted: Binding<Bool>) {
        _searchSubmitted = searchSubmitted
    }
    
    var body: some View {
        Group {
            if viewModel.items.isEmpty {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.filteredItems(searchText: searchText)) { item in
                            NavigationLink(value: item) {
                                ItemCardView(item: item)
                            }
                            .buttonStyle(.plain)
                        }
                        if viewModel.hasNextPage && !isSearching {
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
        .task {
            if !viewModel.items.isEmpty { return }
            await viewModel.getItems()
        }
        .navigationDestination(for: Item.self) { item in
            Text("item view: for \(item.name)")
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


// MARK: - ItemCard
extension ItemGridView {
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
                    Text(item.names.localizedName ?? item.name)
                    HStack{
                        Text("Cost")
                        Spacer()
                        Text("\(item.cost)")
                    }
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
            ItemGridView(searchSubmitted: .constant(false))
                .environmentObject(ImageLoader())
        }
    }
}
