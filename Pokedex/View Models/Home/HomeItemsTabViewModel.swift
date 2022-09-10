//
//  HomeItemsTabViewModel.swift
//  Pokedex
//
//  Created by Tino on 18/8/2022.
//

import Foundation

@MainActor
final class HomeItemsTabViewModel: ObservableObject {
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
    @Published private(set) var viewState = ViewState.loading
    @Published private(set) var searchState = SearchState.idle
    @Published var searchText = "" {
        didSet {
            Task {
                await getItem()
            }
        }
    }
    private var task: Task<Void, Never>?
    private var limit = 20
}


extension HomeItemsTabViewModel {
    var filteredItems: [Item] {
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
    
    func resetSearchState() {
        task?.cancel()
        searchState = .idle
    }
    
    func getItem() async {
        resetSearchState()
        print("getting item 1")
        
        if Task.isCancelled {
            print("Task is cancelled.")
            return
        }
        
        if searchText.isEmpty {
            return
        }

        searchState = .searching
        print("getting item 2")
        task = Task {
            if items.containsItem(named: searchText) {
                searchState = .done
                return
            }
            
            guard let item = try? await Item.from(name: searchText) else {
                #if DEBUG
                print("searchText: \(searchText) nothing was found")
                #endif
                searchState = .error
                return
            }
            
            items.insert(item)
            searchState = .done
            print("getting item 3")
        }
    }
    
    func getItems() async {
        do {
            let list = try await PokeAPI.shared.getResourceList(fromEndpoint: "item", limit: limit)
            nextPageURL = list.next
            await getItems(from: list.results)
            viewState = .loaded
        } catch {
            print("Error in \(#function).\n\(error)")
            viewState = .error(error)
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
                    let item = try? await Item.from(name: result.name)
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
