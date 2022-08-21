//
//  AbilityListViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 20/8/2022.
//

import Foundation

@MainActor
final class AbilityListViewViewModel: ObservableObject {
    @Published private(set) var abilities = Set<Ability>()
    @Published private(set) var nextURL: URL? {
        didSet {
            if nextURL != nil { hasNextPage = true }
            else { hasNextPage = false }
        }
    }
    @Published private(set) var hasNextPage = false
    @Published var viewHasAppeared = false
    @Published private(set) var isLoading = false
    private var task: Task<Void, Never>?
    /// The limit for the PokeAPI abilities query.
    private let limit = 20
}

extension AbilityListViewViewModel {
    /// Returns a filtered and sorted array of Abilities
    ///
    /// - parameter searchText: The text to filter the abilities with.
    /// - returns: An array of sorted Abilities that match the search text.
    func filteredAbilities(searchText: String) -> [Ability] {
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

extension AbilityListViewViewModel {
    func getAbility(named searchText: String) {
        task?.cancel()
        if Task.isCancelled { return }
        let searchText = SearchBarViewModel.sanitizedSearchText(text: searchText)
        if searchText.isEmpty { return }
        
        task = Task {
            self.isLoading = true
            defer {
                Task { @MainActor in
                    self.isLoading = false
                }
            }
            
            // TODO: is this more costly than just running the network call
            if abilities.containsItem(named: searchText) {
                return
            }
            
            let ability = try? await Ability.from(name: searchText)
            if let ability {
                self.abilities.insert(ability)
            }
        }
    }
    /// Gets the first page of abililties from PokeAPI and sets it to the `Ability` set.
    func getAbilities() async {
        isLoading = true
        defer { isLoading = false }
        guard let resourceList = try? await PokeAPI.shared.getResourceList(fromEndpoint: "ability", limit: limit) else {
            print("Error in \(#function).\nResource list was nil.")
            return
        }
        await getAbilities(from: resourceList)
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
        if isLoading { return }
        guard let nextURL else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        guard let resourceList = try? await PokeAPI.shared.getData(for: NamedAPIResourceList.self, url: nextURL) else {
            print("Error in \(#function).\nResource list is nil.")
            return
        }
        
        await getAbilities(from: resourceList)
        
    }
}
