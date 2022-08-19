//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Tino on 19/7/2022.
//

import SwiftUI

@MainActor
final class PokemonDetailViewModel: ObservableObject {
    @Published var pokemon: Pokemon?
    @Published private(set) var pokemonSpecies: PokemonSpecies?
    @Published private(set) var eggGroups = [EggGroup]()
    @Published private(set) var types = [`Type`]()
    @Published private(set) var isLoading = false
    private var settings: Settings?

    func setUp(pokemon: Pokemon, settings: Settings) async {
        isLoading = true
        defer { isLoading = false }
        self.pokemon = pokemon
        self.settings = settings
        pokemonSpecies = await PokemonSpecies.from(name: pokemon.name)
        types = await getTypes()
        eggGroups = await pokemonSpecies?.eggGroups() ?? []
        
    }
}

extension PokemonDetailViewModel {
    func localizedPokemonName(language: Language?) -> String {
        guard let pokemon else { return "Error" }
        return pokemonSpecies?.localizedName(language: language) ?? pokemon.name
    }
    
    var pokemonSeedType: String {
        guard let pokemonSpecies else { return "No species found." }
        return pokemonSpecies.seedType(language: settings?.language)
    }
    /// The url for the pokemon's artwork
    var pokemonImageURL: URL? {
        guard let pokemon else { return nil }
        return pokemon.officialArtWork
    }
    
    /// The number for the pokemon in the pokedex.
    var pokemonID: Int? {
        guard let pokemon else { return nil }
        return pokemon.id
    }
    
    /// Gets the types for this pokemon.
    private func getTypes() async -> [`Type`] {
        guard let pokemon else { return [] }
        var tempTypes = [`Type`]()
        for type in pokemon.types {
            let typeDetails = await `Type`.from(name: type.type.name)
            if let typeDetails {
                tempTypes.append(typeDetails)
            }
        }
        return tempTypes
    }
}
