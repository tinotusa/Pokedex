//
//  ItemCardView.swift
//  Pokedex
//
//  Created by Tino on 23/8/2022.
//

import SwiftUI

struct ItemCardView: View {
    let item: Item
    @Environment(\.appSettings) var appSettings
    @StateObject private var viewModel = ItemCardViewViewModel()
    
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
            .bodyStyle()
            .foregroundColor(.textColour)
        }
        .padding()
        .card()
        .bodyStyle()
        .task {
            viewModel.setUp(settings: appSettings, item: item)
            await viewModel.loadData()
        }
    }
}

private extension ItemCardView {
    enum Constants {
        static let imageSize = 80.0
        static let cornerRadius = 24.0
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

extension Item {
    static var example: Item {
        do {
            return try Bundle.main.loadJSON(ofType: Item.self, filename: "item", extension: "json")
        } catch {
            fatalError("No item.json file.")
        }
    }
}

struct ItemCardView_Previews: PreviewProvider {
    static var previews: some View {
        ItemCardView(item: .example)
            .environmentObject(ImageCache())
    }
}
