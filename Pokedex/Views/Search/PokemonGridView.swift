//
//  PokemonGridView.swift
//  Pokedex
//
//  Created by Tino on 17/8/2022.
//

import SwiftUI
import Combine

// TODO: add state object to this
struct PokemonGridView: View {
    @Environment(\.searchText) var searchText
    @Environment(\.searchSubmitted) var searchSubmitted
    @State private var pokemon: Set<Pokemon> = []
    @State private var nextPage: URL?
    @State private var hasNextPage: Bool = false
    let limit = 20
    @State private var state = SearchState.idle
    
    private let columns: [GridItem] = [
        .init(.adaptive(minimum: 150))
    ]
              
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(filteredPokemon) { pokemon in
                    NavigationLink(value: pokemon) {
                        PokemonCard(pokemon: pokemon)
                    }
                }
                if hasNextPage {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .task {
                            await getNextPokemonPage()
                        }
                }
            }
            .padding(.horizontal)
        }
        .task {
            await getPokemonList()
        }
        .navigationDestination(for: Pokemon.self) { pokemon in
            PokemonDetail(pokemon: pokemon)
        }
        .onReceive(Just(searchSubmitted)) { submitted in
            if searchText.isEmpty { return }
            if !submitted { return }
            Task {
                await getPokemon()
            }
        }
    }
}

private extension PokemonGridView {
    enum SearchState {
        case idle
        case searching
        case isLoading
        case finishedLoading
        case noMoreData
    }
    
    func getPokemon() async {
        guard let pokemon = await Pokemon.from(name: searchText) else {
            return
        }
        self.pokemon.insert(pokemon)
    }
    
    func getPokemonList() async {
        await withTaskGroup(of: Pokemon?.self) { group in
            let baseAPIURL = URL(string: "https://pokeapi.co/api/v2")!
            var request = URLRequest(url: baseAPIURL.appendingPathComponent("pokemon"))
            let queryItems: [URLQueryItem] = [
                .init(name: "offset", value: "0"),
                .init(name: "limit", value: "\(limit)")
            ]
            request.url?.append(queryItems: queryItems)
            let url = request.url
            
            guard let url else { return }
            
            let resourceList = try? await PokeAPI.shared.getData(for: NamedAPIResourceList.self, url: url)
            guard let resourceList else { return }
            if let nextURLString = resourceList.next {
                nextPage = URL(string: nextURLString)
                hasNextPage = true
            } else {
                hasNextPage = false
            }
            
            for resouce in resourceList.results {
                group.addTask {
                    let pokemon = await Pokemon.from(name: resouce.name)
                    return pokemon
                }
            }
            var temp = Set<Pokemon>()
            for await pokemon in group {
                if let pokemon {
                    temp.insert(pokemon)
                }
            }
            self.pokemon = temp
        }
    }
    
    func getNextPokemonPage() async {
        guard let nextPage else { return }
        
        let resourceList = try? await PokeAPI.shared.getData(for: NamedAPIResourceList.self, url: nextPage)
        
        guard let resourceList else { return }
        if let nextURLString = resourceList.next {
            self.nextPage = URL(string: nextURLString)
            hasNextPage = true
        } else {
            hasNextPage = false
        }
        
        await withTaskGroup(of: Pokemon?.self) { group in
            for resouce in resourceList.results {
                group.addTask {
                    let pokemon = await Pokemon.from(name: resouce.name)
                    return pokemon
                }
            }
            var temp = Set<Pokemon>()
            for await pokemon in group {
                if let pokemon {
                    temp.insert(pokemon)
                }
            }
            self.pokemon = self.pokemon.union(temp)
            print("should have set something")
        }
    }
    
    var filteredPokemon: [Pokemon] {
        if searchText.isEmpty {
            return Array(pokemon).sorted()
        }
        return pokemon.filter { pokemon in
            if let id = Int(searchText) {
                return pokemon.id == id
            }
            return pokemon.name.contains(searchText)
        }
        .sorted()
    }
}


struct PokemonGridView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonGridView()
            .environmentObject(ImageLoader())
    }
}
