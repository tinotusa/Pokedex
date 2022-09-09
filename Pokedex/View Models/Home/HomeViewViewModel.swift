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
            headerTitle = LocalizedStringKey(searchTab.rawValue.capitalized)
        }
    }
    @Published var headerTitle: LocalizedStringKey = defaultSearchTab.localizedString
    @Published var searchText: String = ""
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
    }
}
