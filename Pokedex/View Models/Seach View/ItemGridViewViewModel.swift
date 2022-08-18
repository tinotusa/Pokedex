//
//  ItemGridViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 18/8/2022.
//

import Foundation

@MainActor
final class ItemGridViewViewModel: ObservableObject {
    @Published private(set) var items: Set<Item> = []
    private var nextPageURL: URL? {
        didSet {
            if nextPageURL != nil {
                hasNextPage = true
            } else {
                hasNextPage = false
            }
        }
    }
    @Published var hasNextPage: Bool = false
    private var limit = 20
}


extension ItemGridViewViewModel {
    func filteredItems(searchText: String) -> [Item] {
        if searchText.isEmpty { return items.sorted() }
        if let id = Int(searchText) {
            return items.filter { item in
                item.id == id
            }
            .sorted()
        }
        return items.filter { item in
            item.name.contains(searchText)
        }
        .sorted()
    }
    
    func getItem(searchText: String) async {
        if searchText.isEmpty {
            print("In \(#function). Search text is empty.")
            return
        }
        let item = await Item.from(name: searchText)
        if let item {
            items.insert(item)
        }
    }
    
    func getItems() async {
        do {
            let list = try await PokeAPI.shared.getResourceList(fromEndpoint: "item", limit: limit)
            nextPageURL = list.next
            await getItems(from: list.results)
        } catch {
            print("Error in \(#function).\n\(error)")
        }
    }
    
    func getNextItemsPage() async {
        guard let nextPageURL else {
            return
        }
        do {
            let list = try await PokeAPI.shared.getData(for: NamedAPIResourceList.self, url: nextPageURL)
            self.nextPageURL = list.next
            await getItems(from: list.results)
        } catch {
            print("Error in \(#function).\n\(error)")
        }
    }
    
    private func getItems(from list: [NamedAPIResource]) async {
        await withTaskGroup(of: Item?.self) { group in
            for result in list {
                group.addTask {
                    let item = await Item.from(name: result.name)
                    return item
                }
            }
            var tempItems = Set<Item>()
            for await item in group {
                if let item {
                    tempItems.insert(item)
                }
            }
            self.items.formUnion(tempItems)
        }
    }
}
