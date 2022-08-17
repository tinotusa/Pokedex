//
//  SearchViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 5/8/2022.
//

import SwiftUI

final class SearchViewViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchTab = SearchTab.pokemon {
        didSet {
            headerTitle = LocalizedStringKey(searchTab.rawValue.capitalized)
        }
    }
    @Published var headerTitle: LocalizedStringKey = "No selection"
    
    @Published var pokemon = Set<Pokemon>()
    @Published var searchSubmitted = false
    
    @MainActor
    func search() async {
        switch searchTab {
        case .pokemon:
            guard let pokemon = await Pokemon.from(name: searchText) else {
                return
            }
            self.pokemon.insert(pokemon)
        default: print("detaul case called")
        }
    }

    
//    @Published var isLoading = false
//    @Published var hasNextPage = false
//    @Published var foundPokemon: Bool?
//
//    private let limit = 20
//    private var nextPage: URL?
//
//    init() {
//        Task {
//            await getPokemon()
//        }
//    }
//
//    @MainActor
//    func getNextPokemonPage() async {
//        isLoading = true
//
//        guard let nextPage else { return }
//
//        let resourceList = try? await PokeAPI.shared.getData(for: NamedAPIResourceList.self, url: nextPage)
//
//        guard let resourceList else { return }
//        if let nextURLString = resourceList.next {
//            self.nextPage = URL(string: nextURLString)
//            hasNextPage = true
//        } else {
//            hasNextPage = false
//        }
//
//        await withTaskGroup(of: Pokemon?.self) { group in
//            for resouce in resourceList.results {
//                group.addTask {
//                    let pokemon = await Pokemon.from(name: resouce.name)
//                    return pokemon
//                }
//            }
//            var temp = Set<Pokemon>()
//            for await pokemon in group {
//                if let pokemon {
//                    temp.insert(pokemon)
//                }
//            }
//            self.pokemon = self.pokemon.union(temp)
//            print("should have set something")
//            isLoading = false
//        }
//    }

}

extension SearchViewViewModel {
    enum SearchTab: String, CaseIterable, Identifiable {
        case pokemon
        case items
        case moves
        case abilities
        
        var id: Self { self }
    }
}
