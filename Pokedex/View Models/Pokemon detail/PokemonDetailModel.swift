//
//  PokemonDetailModel.swift
//  Pokedex
//
//  Created by Tino on 19/7/2022.
//

import SwiftUI

/// The model for the pokemon detail view.
struct PokemonDetailModel {
    private let pokemon: Pokemon
    private var pokemonSpecies: PokemonSpecies?
    private var eggGroups = [EggGroups]()
    private var pokeAPI: PokeAPI?
    private var types = [PokemonType]()
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
}

// MARK: - Computed properties
extension PokemonDetailModel {
    /// The url for the pokemon's artwork
    var pokemonImageURL: URL? {
        pokemon.officialArtWork
    }
    
    /// The localized name for the pokemon.
    var pokemonName: String {
        guard let pokemonSpecies else { return "Error" }
        let availableLanguages = pokemonSpecies.names.map { name in
            name.language.languageCode
        }
        
        let deviceLanguage = Bundle.preferredLocalizations(from: availableLanguages).first!
        
        let pokemonName = pokemonSpecies.names.first(where: { name in
            name.language.languageCode == deviceLanguage
        })
        
        return pokemonName?.name ?? self.pokemon.name
    }
    
    /// The localized names for the pokemons egg group.
    var eggGroupNames: String {
        var names = [String]()
        for eggGroup in eggGroups {
            let availableLanguages = eggGroup.names.map { name in
                name.language.languageCode
            }
            let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguages).first!
            let name = eggGroup.names.first { name in
                name.language.languageCode == deviceLanguageCode
            }
            if let name {
                names.append(name.name)
            }
        }
        return ListFormatter.localizedString(byJoining: names)
    }
    
    /// The colour for this pokemon's type.
    var pokemonTypeColour: Color {
        pokemon.typeColour
    }
    
    /// The type(s) for this pokemon (e.g grass).
    var pokemonTypes: [PokemonTypeDetails] {
        pokemon.types
    }
    
    /// The number for the pokemon in the pokedex.
    var pokemonID: Int {
        pokemon.id
    }
}



// MARK: - Functions
extension PokemonDetailModel {
    /// Sets up the model.
    mutating func setUp(pokeAPI: PokeAPI) async {
        self.pokeAPI = pokeAPI
        pokemonSpecies = await pokeAPI.pokemonSpecies(named: pokemon.name)
        types = await getTypes()
        await getEggGroups()
    }
    /// Gets the types for this pokemon.
    private mutating func getTypes() async -> [PokemonType] {
        guard let pokeAPI else { return [] }
        var tempTypes = [PokemonType]()
        for type in pokemon.types {
            let typeDetails = await pokeAPI.pokemonType(named: type.type.name)
            if let typeDetails {
                tempTypes.append(typeDetails)
            }
        }
        return tempTypes
    }
    
    /// Gets all the egg groups for this pokemon.
    private mutating func getEggGroups() async {
        guard let pokeAPI else {
            print("Error in \(#function): PokeAPI is nil.")
            return
        }
        if pokemonSpecies == nil {
            return
        }
        for eggGroups in pokemonSpecies!.eggGroups {
            guard let group = await pokeAPI.eggGroups(named: eggGroups.name) else {
                continue
            }
            self.eggGroups.append(group)
        }
    }
}
