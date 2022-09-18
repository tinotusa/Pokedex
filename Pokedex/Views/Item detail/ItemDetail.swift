//
//  ItemDetail.swift
//  Pokedex
//
//  Created by Tino on 23/8/2022.
//

import SwiftUI

struct ItemDetail: View {
    let item: Item
    @StateObject private var viewModel = ItemDetailViewModel()
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        VStack {
            HeaderBar {
                Button(action: {}) {
                    Image(systemName: "heart")
                }
            }
            
            ScrollView(showsIndicators: false) {
                VStack {
                    switch viewModel.viewState {
                    case .loading:
                        LoadingView()
                            .task {
                                await viewModel.loadData(item: item, settings: settingsManager.settings)
                            }
                    case .loaded:
                        itemDetail
                    case .error(let error):
                        ErrorView(text: error.localizedDescription)
                    case .empty:
                        Text("Failed to load data.")
                    }
                }
            }
        }
        .toolbar(.hidden)
        .padding()
        .bodyStyle()
        .foregroundColor(.textColour)
        .background(Color.backgroundColour)
    }
}

// MARK: Subviews
private extension ItemDetail {
    @ViewBuilder
    var attributesList: some View {
        if item.attributes.isEmpty {
            Text("0")
        } else {
            VStack(alignment: .leading) {
                ForEach(viewModel.itemAttributeNames, id: \.self) { attributeName in
                    Text(attributeName)
                }
            }
        }
    }
    
    var heldBy: some View {
        HStack {
            Text(viewModel.itemInfo[.heldBy, default: "Error"])
            Spacer()
            if !item.heldByPokemon.isEmpty {
                NavigationLink {
                    PokemonListView(
                        title: viewModel.localizedItemName,
                        id: item.id,
                        description: "Pokemon that hold this item.",
                        pokemonURLS: item.heldByPokemon.map { $0.pokemon.url }
                    )
                } label: {
                    ShowMoreButton()
                }
            }
        }
    }
    
    var itemDetail: some View {
        VStack(alignment: .leading) {
            DetailImage(url: item.sprites.default)
            HeaderWithID(title: viewModel.localizedItemName, id: item.id)
            
            Text(viewModel.localizedFlavorTextEntry)
            Divider()
            
            Text(viewModel.localizedEffectEntry)
            Divider()
            
            Text("About")
                .subHeaderStyle()
            
            Grid(alignment: .leadingFirstTextBaseline, verticalSpacing: 10) {
                ForEach(ItemDetailViewModel.ItemInfoKey.allCases) { itemInfoKey in
                    GridRow {
                        Text(itemInfoKey.title)
                            .gridRowTitleStyle()
                        switch itemInfoKey {
                        case .attributes: attributesList
                        case .heldBy: heldBy
                        default: Text(viewModel.itemInfo[itemInfoKey, default: "Error"])
                        }
                        
                    }
                }
            }
        }
    }
}

struct ItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetail(item: .example)
            .environmentObject(ImageCache())
            .environmentObject(SettingsManager())
    }
}
