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
                        Text(error.localizedDescription)
                    case .empty:
                        Text("Failed to load data.")
                    }
                }
            }
        }
        .toolbar(.hidden)
        .padding()
        .background(Color.backgroundColour)
        .fullScreenCover(isPresented: $viewModel.showAllPokemonView) {
            ItemPokemonListView(itemDetailViewModel: viewModel)
                .preferredColorScheme(settingsManager.isDarkMode ? .dark : .light)
        }
    }
}

private extension ItemDetail {
    enum Constants {
        static let imageSize = 320.0
        static let smallImageSize = 80.0
    }
    
    var itemImage: some View {
        ImageLoaderView(url: item.sprites.default) {
            ProgressView()
        } content: { image in
            image
                .interpolation(.none)
                .resizable()
                .scaledToFit()
        }
        .frame(width: Constants.imageSize, height: Constants.imageSize)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var itemDetail: some View {
        VStack(alignment: .leading) {
            itemImage
                
            HStack {
                Text(viewModel.localizedItemName)
                Spacer()
                Text("#\(String(format: "%03d", item.id))")
                    .fontWeight(.ultraLight)
            }
            .headerStyle()
            
            Text(viewModel.localizedFlavorTextEntry)
                
            Divider()
            Text(viewModel.localizedEffectEntry)
            Divider()
            Text("About")
                .subHeaderStyle()
            
            Grid(alignment: .leadingFirstTextBaseline, verticalSpacing: 10) {
                GridRowItem(title: "ID") { Text("\(item.id)") }
                GridRowItem(title: "Cost") { Text("\(item.cost)") }
                if let flingPower = item.flingPower {
                    GridRowItem(title: "Fling power") { Text("\(flingPower)") }
                }
                if item.flingEffect != nil {
                    GridRowItem(title: "Fling effect") { Text("\(viewModel.localizedFlingEffectEntry)") }
                }
                GridRowItem(title: "Attributes") {
                    if !viewModel.hasItemAttributes {
                        Text("None")
                    } else {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.itemAttributes) { itemAttribute in
                                Text(
                                    itemAttribute
                                        .names
                                        .localizedName(language: settingsManager.language, default: itemAttribute.name)
                                        .replacingOccurrences(of: "_", with: " ")
                                )
                            }
                        }
                    }
                }
                GridRowItem(title: "Category") { Text("\(viewModel.localizedCategoryName)") }
                GridRow(alignment: .center) {
                    Text("Held by")
                        .gridRowTitleStyle()
                    HStack {
                        Text("\(viewModel.heldByPokemonCount) pokemon")
                        Spacer()
                        if viewModel.isHeldByPokemon {
                            Button {
                                viewModel.showAllPokemonView = true
                            } label: {
                                Text("Show pokemon")
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .bodyStyle()
        .foregroundColor(.textColour)
    }
}

struct ItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetail(item: .example)
            .environmentObject(ImageCache())
            .environmentObject(SettingsManager())
    }
}
