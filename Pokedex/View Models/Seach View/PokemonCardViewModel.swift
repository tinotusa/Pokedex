//
//  PokemonCardViewModel.swift
//  Pokedex
//
//  Created by Tino on 22/8/2022.
//

import Foundation

@MainActor
final class PokemonCardViewModel: ObservableObject {
    @Published private(set) var typeNames = [String]()
    @Published private(set) var pokemonSpecies: PokemonSpecies?
    
    private var appSettings: Settings?
    private var pokemon: Pokemon?
    
    func setUp(pokemon: Pokemon, appSettings: Settings) {
        self.pokemon = pokemon
        self.appSettings = appSettings
    }
    
    func loadData() async {
        guard let pokemon else { return }
        typeNames = pokemon.getTypes()
        pokemonSpecies = try? await PokemonSpecies.from(name: pokemon.name)
    }
    
    var localizedPokemonName: String {
        guard let pokemon else { return  "Error" }
        guard let pokemonSpecies else { return  "Error" }
        guard let appSettings else { return  "Error" }
        return pokemonSpecies.names.localizedName(language: appSettings.language, default: pokemon.name)
    }
}
