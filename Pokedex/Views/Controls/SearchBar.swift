//
//  SearchBar.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

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

struct SearchBar: View {
    let placeholder: LocalizedStringKey
    @EnvironmentObject private var viewModel: SearchBarViewModel
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            TextField(text: $viewModel.searchText, prompt: Text(placeholder)) {
                Text("Search bar")
            }
            .subHeaderStyle()
            .foregroundColor(.searchBarTextColour)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .submitLabel(.search)
            .onSubmit {
                action?()
            }
            
            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.clearText()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .renderingMode(.original)
                }
                .transition(.opacity)
            }
            
            Button {
                action?()
            } label: {
                Image(systemName: "magnifyingglass")
                    .subHeaderStyle()
                    .foregroundColor(.searchBarTextColour)
            }
        }
        .foregroundColor(.searchBarColour)
        .animation(.easeInOut, value: viewModel.searchText)
        .padding()
        .background(Color.searchBarColour)
        .cornerRadius(Constants.searchBarCornerRadius)
    }
}

private extension SearchBar {
    struct Constants {
        static let searchBarCornerRadius = 26.0
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(placeholder: "Placeholder")
            .environmentObject(SearchBarViewModel())
    }
}
