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
    @Published private(set) var viewState = ViewState.loading
    private var settings: Settings?
}

extension PokemonDetailViewModel {
    func load(pokemon: Pokemon, settings: Settings) async {
        setUp(pokemon: pokemon, settings: settings)
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { @MainActor in
                self.pokemonSpecies = try? await PokemonSpecies.from(name: pokemon.species.name)
            }
            group.addTask { @MainActor in
                self.types = await self.getTypes()
            }
            group.addTask { @MainActor in
                self.eggGroups = await self.pokemonSpecies?.eggGroups() ?? []
            }
            viewState = .loaded
        }
    }
    
    func localizedPokemonName(language: Language?) -> String {
        guard let pokemon else { return "Error" }
        return pokemonSpecies?.localizedName(language: language) ?? pokemon.name
    }
    
    var pokemonSeedType: String {
        guard let pokemonSpecies else { return "Error" }
        return pokemonSpecies.seedType(language: settings?.language)
    }
    
    /// The url for the pokemon's artwork
    var pokemonImageURL: URL? {
        pokemon?.officialArtWork
    }
    
    /// The number for the pokemon in the pokedex.
    var pokemonID: Int? {
        pokemon?.id
    }
}

private extension PokemonDetailViewModel {
    private func setUp(pokemon: Pokemon, settings: Settings) {
        self.settings = settings
        self.pokemon = pokemon
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
