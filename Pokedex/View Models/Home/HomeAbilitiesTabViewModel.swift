//
//  HomeAbilitiesTabViewModel.swift
//  Pokedex
//
//  Created by Tino on 20/8/2022.
//

import Foundation

@MainActor
final class HomeAbilitiesTabViewModel: ObservableObject {
    @Published private(set) var abilities = Set<Ability>()
    @Published private(set) var nextURL: URL? {
        didSet {
            if nextURL != nil { hasNextPage = true }
            else { hasNextPage = false }
        }
    }
    @Published private(set) var hasNextPage = false
    @Published private(set) var viewLoadingState = ViewState.loading
    @Published private(set) var searchState = SearchState.idle
    @Published var searchText = "" {
        didSet {
            getAbility()
        }
    }
    private var task: Task<Void, Never>?
    /// The limit for the PokeAPI abilities query.
    private let limit = 20
}

private extension HomeAbilitiesTabViewModel {
    func resetSearchState() {
        searchState = .idle
    }
}

extension HomeAbilitiesTabViewModel {
    /// A filtered and sorted array of Abilities
    var filteredAbilities: [Ability] {
        if searchText.isEmpty { return abilities.sorted() }

        if let id = Int(searchText) {
            return abilities.filter { ability in
                ability.id == id
            }
            .sorted()
        }

        return abilities.filter { ability in
            ability.name.contains(searchText)
        }
        .sorted()
    }
}

extension HomeAbilitiesTabViewModel {
    func getAbility() {
        resetSearchState()
        
        task?.cancel()
        if Task.isCancelled { return }
        if searchText.isEmpty { return }
        
        searchState = .searching
        
        task = Task {
            if abilities.containsItem(named: searchText) {
                searchState = .done
                return
            }
            
            guard let ability = try? await Ability.from(name: searchText) else {
                searchState = .error
                return
            }
        
            self.abilities.insert(ability)
            searchState = .done
        }
    }
    
    /// Gets the first page of abililties from PokeAPI and sets it to the `Ability` set.
    func getAbilities() async {
        do {
            let resourceList = try await PokeAPI.shared.getResourceList(fromEndpoint: "ability", limit: limit)
            await getAbilities(from: resourceList)
            viewLoadingState = .loaded
        } catch {
            #if DEBUG
            print("Error in \(#function).\nResource list was nil.")
            #endif
            viewLoadingState = .error(error)
        }
    }
    
    /// Gets and sets the abilities from the named api resource.
    /// This function also sets the `nextURL` from the `NamedAPIResourceList`.
    ///
    /// - parameter resourceList: The `NamedAPIResourceList` to get the abilities from.
    private func getAbilities(from resourceList: NamedAPIResourceList) async {
        let (abilities, resourceNextURL) =  await PokeAPI.shared.getItems(ofType: Ability.self, from: resourceList)
        self.abilities.formUnion(abilities)
        self.nextURL = resourceNextURL
    }
    
    /// Gets the next page of abilities from `nextURL`.
    func getNextAbilitesPage() async {
        guard let nextURL else { return }
        
        guard let resourceList = try? await PokeAPI.shared.getData(for: NamedAPIResourceList.self, url: nextURL) else {
            print("Error in \(#function).\nResource list is nil.")
            return
        }
        
        await getAbilities(from: resourceList)
        
    }
}
