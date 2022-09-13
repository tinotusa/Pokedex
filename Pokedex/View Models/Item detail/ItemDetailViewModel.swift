//
//  ItemDetailViewModel.swift
//  Pokedex
//
//  Created by Tino on 23/8/2022.
//

import SwiftUI

final class ItemDetailViewModel: ObservableObject {
    @Published private(set) var item: Item?
    @Published private(set) var itemFlingEffect: ItemFlingEffect?
    @Published private(set) var itemAttributes = [ItemAttribute]()
    @Published private(set) var itemCategory: ItemCategory?
    @Published var showingHeldByPokemonView = false
    @Published private(set) var viewState = ViewState.loading
    @Published private(set) var itemInfo = [ItemInfoKey: String]()
    private var settings: Settings?
}


extension ItemDetailViewModel {
    private func setUp(item: Item, settings: Settings) {
        self.item = item
        self.settings = settings
    }
    
    func showHeldByPokemonView() {
        showingHeldByPokemonView = true
    }
    
    @MainActor
    func loadData(item: Item, settings: Settings) async {
        setUp(item: item, settings: settings)
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { @MainActor [self] in
                guard let flingEffect = item.flingEffect else {
                    return
                }
                itemFlingEffect = try? await ItemFlingEffect.from(name: flingEffect.name)
                // TODO: do i want to show a different view if this is nil?
            }
            
            for attribute in item.attributes {
                group.addTask { @MainActor [self] in
                    self.itemAttributes = []
                    let itemAttribute = try? await ItemAttribute.from(name: attribute.name)
                    if let itemAttribute {
                        itemAttributes.append(itemAttribute)
                    }
                }
            }
            
            group.addTask { @MainActor [self] in
                itemCategory = try? await ItemCategory.from(name: item.category.name)
            }
            
            await group.waitForAll()
            getItemInfo()
            viewState = .loaded
        }
    }
    
    enum ItemInfoKey: String, CaseIterable, Identifiable {
        case itemID = "ID"
        case cost = "cost"
        case flingPower = "fling power"
        case flingEffect = "fling effect"
        case attributes = "attributes"
        case category = "category"
        case heldBy = "held by"
        
        var id: Self { self }
        
        var title: LocalizedStringKey {
            switch self {
            case .itemID: return LocalizedStringKey("ID")
            default: return LocalizedStringKey(self.rawValue.localizedCapitalized)
            }
        }
    }
    
    @MainActor
    func getItemInfo() {
        guard let item else { return }
        
        itemInfo[.itemID] = "\(item.id)"
        itemInfo[.cost] = "\(item.cost)"
        itemInfo[.flingPower] = "\(item.flingPower ?? 0)"
        if itemFlingEffect != nil {
            itemInfo[.flingEffect] = localizedFlingEffectEntry
        } else {
            itemInfo[.flingEffect] = "N/A"
        }
        itemInfo[.attributes] = "\(item.attributes.count)"
        itemInfo[.category] = localizedCategoryName
        itemInfo[.heldBy] = "\(item.heldByPokemon.count) pokemon"
    }
    
    var itemAttributeNames: [String] {
        itemAttributes.map { attribute in
            attribute.names
                .localizedName(language: settings?.language, default: attribute.name)
                .replacingOccurrences(of: "_", with: " ")
        }
    }
    
}


// MARK: Computed properties
extension ItemDetailViewModel {
    var hasItemAttributes: Bool {
        !itemAttributes.isEmpty
    }
    
    var isHeldByPokemon: Bool {
        guard let item else { return false }
        return !item.heldByPokemon.isEmpty
    }
    var heldByPokemonCount: Int {
        guard let item else { return 0 }
        return item.heldByPokemon.count
    }
    
    var localizedItemName: String {
        guard let item else {
            print("Error in \(#function). item is nil.")
            return "Error"
        }
        guard let settings else {
            print("Error in \(#function). Settings is nil.")
            return "Error"
        }
        return item.names.localizedName(language: settings.language, default: item.name)
    }
    
    var itemID: String {
        guard let item else { return "Error" }
        return String(format: "#%03d", item.id)
    }
    
    var localizedFlavorTextEntry: String {
        guard let item else {
            print("Error in \(#function). item is nil.")
            return "Error"
        }
        guard let settings else {
            print("Error in \(#function). Settings is nil.")
            return "Error"
        }
        
        return item.flavorTextEntries.localizedFlavorTextEntry(
            language: settings.language,
            default: "Error"
        )
        .replacingOccurrences(of: "\n", with: " ")
    }
    
    var localizedEffectEntry: String {
        guard let item else {
            print("Error in \(#function). item is nil.")
            return "Error"
        }
        guard let settings else {
            print("Error in \(#function). Settings is nil.")
            return "Error"
        }
        
        var text = item.effectEntries.localizedEffectEntry(language: settings.language, default: "Error")
        guard let colonIndex = text.firstIndex(of: ":") else {
            return text
        }
        
        text = text.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)

        let startOfText = String(text[...colonIndex])
        var restOfText = String(text[colonIndex...])
        restOfText.removeFirst()
        restOfText = restOfText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return "\(startOfText)\n\n\(restOfText)"
    }
    
    var localizedCategoryName: String {
        guard let itemCategory else {
            print("Error in \(#function). Item category is nil.")
            return "Error"
        }
        guard let settings else {
            print("Error in \(#function). Settings is nil.")
            return "Error"
        }
        return itemCategory.names.localizedName(language: settings.language, default: itemCategory.name)
    }
    
    var localizedFlingEffectEntry: String {
        guard let itemFlingEffect else {
            print("Error in \(#function). Item fling effect is nil.")
            return "Error"
        }
        guard let settings else {
            print("Error in \(#function). Settings is nil.")
            return "Error"
        }
        return itemFlingEffect.effectEntries.localizedEffectName(language: settings.language, default: itemFlingEffect.name)
    }
}
