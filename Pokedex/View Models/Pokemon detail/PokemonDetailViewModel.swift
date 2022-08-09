//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Tino on 19/7/2022.
//

import SwiftUI

@MainActor
final class PokemonDetailViewModel: ObservableObject {
    @Published var pokemon: Pokemon
    @Published private(set) var pokemonSpecies: PokemonSpecies?
    @Published private(set) var eggGroups = [EggGroup]()
    @Published private(set) var types = [`Type`]()
    @Published private(set) var isLoading = false
    @Published private(set) var settingsManager: SettingsManager?
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        isLoading = true
        Task {
            pokemonSpecies = await PokemonSpecies.from(name: pokemon.name)
            types = await getTypes()
            eggGroups = await pokemonSpecies?.eggGroups() ?? []
            isLoading = false
        }
    }
    
    func setUp(settingsManager: SettingsManager) {
        self.settingsManager = settingsManager
    }
}

extension PokemonDetailViewModel {
    var localizedPokemonName: String {
        pokemonSpecies?.localizedName ?? pokemon.name
    }
    
    var pokemonSeedType: String {
        guard let pokemonSpecies else { return "No species found." }
        if let settings = settingsManager?.settings, let language = settings.language {
            return pokemonSpecies.seedType(language: language.name)
        }
        return pokemonSpecies.seedType()
    }
    /// The url for the pokemon's artwork
    var pokemonImageURL: URL? {
        pokemon.officialArtWork
    }
    
    /// The number for the pokemon in the pokedex.
    var pokemonID: Int {
        pokemon.id
    }
    
    /// Gets the types for this pokemon.
    private func getTypes() async -> [`Type`] {
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
