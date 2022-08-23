//
//  SearchBarViewModel.swift
//  Pokedex
//
//  Created by Tino on 23/8/2022.
//

import Foundation

@MainActor
final class SearchBarViewModel: ObservableObject {
    @Published var searchText = "" {
        didSet {
            if !searchText.isEmpty {
                isSearching = true
            }
            else { isSearching = false }
        }
    }
    @Published private(set) var isSearching = false
    
    var sanitizedSearchText: String {
        Self.sanitizedSearchText(text: searchText)
    }
    
    static func sanitizedSearchText(text: String) -> String {
        text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "-")
            .lowercased()
    }
    
    func clearText() {
        searchText = ""
    }
}
