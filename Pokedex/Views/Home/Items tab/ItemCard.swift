//
//  ItemCard.swift
//  Pokedex
//
//  Created by Tino on 23/8/2022.
//

import SwiftUI

struct ItemCard: View {
    let item: Item
    @StateObject private var viewModel = ItemCardViewViewModel()
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        HStack {
            itemImage
            VStack(alignment: .leading) {
                HStack{
                    Text(viewModel.localizedItemName)
                    Spacer()
                    Text(viewModel.localizedCategoryName)
                }
                .lineLimit(1)
                Text(viewModel.localizedFlavorText)
                    .bodyStyle()
                    .lineLimit(2)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding()
        .card()
        .bodyStyle()
        .foregroundColor(.textColour)
        .task {
            viewModel.setUp(settings: settingsManager.settings, item: item)
            await viewModel.loadData()
        }
    }
}

private extension ItemCard {
    enum Constants {
        static let imageSize = 80.0
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
    }
}

struct ItemCard_Previews: PreviewProvider {
    static var previews: some View {
        ItemCard(item: .example)
            .environmentObject(ImageCache())
            .environmentObject(SettingsManager())
    }
}
