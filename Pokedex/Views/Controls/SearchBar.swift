//
//  SearchBar.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

struct SearchBar: View {
    let placeholder: LocalizedStringKey
    @EnvironmentObject private var viewModel: SearchBarViewModel
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.searchBarTextColour)
                
                TextField(text: $viewModel.searchText, prompt: Text(placeholder)) {
                    Text("Search bar")
                }
                .foregroundColor(.searchBarTextColour)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .submitLabel(.search)
            }
            .padding()
            .background(Color.searchBarColour)
            .cornerRadius(Constants.searchBarCornerRadius)
            
            if viewModel.isSearching {
                cancelButton
            }
        }
        .subHeaderStyle()
        .foregroundColor(.searchBarColour)
        .animation(.easeInOut, value: viewModel.searchText)
        .padding()
    }
}

private extension SearchBar {
    struct Constants {
        static let searchBarCornerRadius = 26.0
    }
    
    var cancelButton: some View {
        Button {
            viewModel.clearText()
        } label: {
            Text("Cancel", comment: "Button label: Cancels the search.")
                .bodyStyle()
        }
        .transition(.move(edge: .trailing).combined(with: .opacity))
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.backgroundCircleColour
            SearchBar(placeholder: "Search")
                .environmentObject(SearchBarViewModel())
        }
    }
}
