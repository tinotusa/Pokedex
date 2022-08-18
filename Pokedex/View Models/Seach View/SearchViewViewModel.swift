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
