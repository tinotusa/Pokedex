//
//  SearchBar.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

struct SearchBar: View {
    let placeholder: LocalizedStringKey
    @Binding var text: String
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            TextField(text: $text, prompt: Text(placeholder)) {
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
            
            if !text.isEmpty {
                Button {
                    text = ""
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
        .animation(.easeInOut, value: text)
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
        SearchBar(placeholder: "Placeholder", text: .constant(""))
    }
}
