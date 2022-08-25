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
        await withTaskGroup(of: Void.self) { group in
            isLoading = true
            defer {
                Task { @MainActor in
                    isLoading = false
                }
            }
            self.pokemon = pokemon
            self.settings = settings
            group.addTask { @MainActor in
                print("1")
                self.pokemonSpecies = try? await PokemonSpecies.from(name: pokemon.species.name)
            }
            group.addTask { @MainActor in
                print("2")
                self.types = await self.getTypes()
            }
            group.addTask { @MainActor in
                print("3")
                self.eggGroups = await self.pokemonSpecies?.eggGroups() ?? []
            }
        }
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
            let typeDetails = try? await `Type`.from(name: type.type.name)
            if let typeDetails {
                tempTypes.append(typeDetails)
            }
        }
        return tempTypes
    }
}
