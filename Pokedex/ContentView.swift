//
//  ContentView.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText = "dragonite"
    @State private var pokemon: [Pokemon] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(placeholder: "Search for pokemon", text: $searchText, results: $pokemon)
                ScrollView(showsIndicators: false) {
                    ForEach(pokemon) { pokemon in
                        NavigationLink(value: pokemon) {
                            PokemonRow(pokemon: pokemon)
                        }
                   }
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .padding()
            .background {
                Color.backgroundColour
                    .ignoresSafeArea()
            }
            .overlay {
                if searchText.isEmpty && pokemon.isEmpty {
                    Text("Search for a pokemon.")
                        .foregroundColor(.secondary)
                }
            }
            .navigationDestination(for: Pokemon.self) { pokemon in
                PokemonDetail(pokemon: pokemon)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PokeAPI())
    }
}
