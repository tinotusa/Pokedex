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
    @Binding var results: [Pokemon]
    @EnvironmentObject var pokeAPI: PokeAPI
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text, prompt: Text(placeholder))
                .autocorrectionDisabled(true)
                .onSubmit {
                    search()
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
            Divider()
                .frame(maxHeight: 30)
            Button {
                search()
            } label: {
                Image(systemName: "magnifyingglass")
                    .tint(.grayTextColour)
            }
        }
        .animation(.easeInOut, value: text)
        .padding()
        .background(Color.searchBarColour)
        .cornerRadius(14)
    }
   
}

// MARK: - Functions
private extension SearchBar {
    func search() {
        Task {
            guard let pokemon = await pokeAPI.pokemon(named: text) else {
                return
            }
            if results.contains(pokemon) {
                return
            }
            results.append(pokemon)
            text = ""
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(placeholder: "Placeholder", text: .constant(""), results: .constant([]))
    }
}
