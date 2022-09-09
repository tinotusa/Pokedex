//
//  ItemCardViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 9/9/2022.
//

import Foundation

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
