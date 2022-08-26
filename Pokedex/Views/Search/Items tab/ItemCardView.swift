//
//  ItemCardView.swift
//  Pokedex
//
//  Created by Tino on 23/8/2022.
//

import SwiftUI

@MainActor
final class ItemCardViewViewModel: ObservableObject {
    @Published private(set) var settings: Settings?
    @Published private(set) var item: Item?
    @Published private(set) var itemCategory: ItemCategory?
    
    init() {
        
    }
}

extension ItemCardViewViewModel {
    var localizedItemName: String {
        guard let item else {
            print("Error in \(#function). Item is nil.")
            return "Error"
        }
        return item.names.localizedName(language: settings?.language, default: item.name)
    }
    
    var localizedCategoryName: String {
        guard let settings else {
            print("Error in \(#function). Settings are nil.")
            return "Error"
        }
        guard let itemCategory else {
            print("Error in \(#function). itemCategory is nil.")
            return "Error"
        }
        return itemCategory.names.localizedName(language: settings.language, default: itemCategory.name)
    }
    
    var localizedFlavorText: String {
        guard let item else {
            print("Error in \(#function). Item is nil.")
            return "Error"
        }
        guard let settings else {
            print("Error in \(#function). Settings are nil.")
            return "Error"
        }
        let availableLangauges = item.flavorTextEntries.map { entry in
            entry.language.name
        }
        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLangauges, forPreferences: nil).first!
        
        let flavorText = item.flavorTextEntries.first {
            $0.language.name == (settings.language != nil ? settings.language!.name : deviceLanguageCode)
        }
        if let flavorText {
            return flavorText.text.replacingOccurrences(of: "\n", with: " ")
        }
        print("Error in \(#function). No flavor text was found.")
        return "Error"
    }
}

extension ItemCardViewViewModel {
    func setUp(settings: Settings, item: Item) {
        self.settings = settings
        self.item = item
    }
    
    func loadData() async {
        guard let item else {
            print("Error in \(#function). Item is nil.")
            return
        }
        itemCategory = try? await ItemCategory.from(name: item.category.name)
    }
}

struct ItemCardView: View {
    let item: Item
    @Environment(\.appSettings) var appSettings
    @StateObject private var viewModel = ItemCardViewViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                itemImage
                VStack(alignment: .leading) {
                    HStack{
                        Text(viewModel.localizedItemName)
                        Spacer()
                        Text(viewModel.localizedCategoryName)
                    }
                    Text(viewModel.localizedFlavorText)
                        .bodyStyle()
                        .lineLimit(2)
                        .foregroundColor(.gray)
                }
                .bodyStyle()
                .foregroundColor(.textColour)
            }
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
