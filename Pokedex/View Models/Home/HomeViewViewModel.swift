//
//  HomeViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 5/8/2022.
//

import SwiftUI

final class HomeViewViewModel: ObservableObject {
    private static let defaultSearchTab = SearchTab.pokemon
    @Published var searchTab = defaultSearchTab {
        didSet {
            headerTitle = searchTab.localizedString
            searchPlaceholder = searchTab.placeholderString
        }
    }
    @Published var headerTitle: LocalizedStringKey = defaultSearchTab.localizedString
    @Published var searchText: String = ""
    @Published var searchPlaceholder: LocalizedStringKey = defaultSearchTab.placeholderString
    @Published var showSettingsView = false
}

extension HomeViewViewModel {
    enum SearchTab: String, CaseIterable, Identifiable {
        case pokemon
        case items
        case moves
        case abilities
        
        var id: Self { self }
        
        var localizedString: LocalizedStringKey {
            LocalizedStringKey(self.rawValue.localizedCapitalized)
        }
        
        var placeholderString: LocalizedStringKey {
            switch self {
            case .pokemon: return "Search for pokemon"
            case .items: return "Search for items"
            case .moves: return "Search for moves"
            case .abilities: return "Search for abilities"
            }
        }
    }
}
