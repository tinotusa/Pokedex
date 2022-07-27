//
//  AboutTabModel.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

struct AboutTabModel {
    private let pokemon: Pokemon
    private(set) var pokemonSpecies: PokemonSpecies?
    private(set) var eggGroups = [EggGroup]()
    private(set) var abilities = [Ability]()
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
}

extension AboutTabModel {
    /// The pokemons seed type.
    var pokemonSeedType: String {
        guard let pokemonSpecies else { return "Error" }
        return pokemonSpecies.seedType
    }
    
    /// The localized names for the pokemons egg group.
    var eggGroupNames: String {
        var names = [String]()
        for eggGroup in eggGroups {
            let availableLanguages = eggGroup.names.map { name in
                name.language.name
            }
            let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguages).first!
            let name = eggGroup.names.first { name in
                name.language.name == deviceLanguageCode
            }
            if let name {
                names.append(name.name)
            }
        }
        return ListFormatter.localizedString(byJoining: names)
    }

    
    /// The number for the pokemon in the pokedex.
    var pokemonID: Int {
        pokemon.id
    }
    
    /// The pokemon's height in meters.
    var pokemonHeight: Double {
        Double(pokemon.height) / 10.0
    }
    
    /// The pokemon's weight in kilograms.
    var pokemonWeight: Double {
        Double(pokemon.weight) / 10.0
    }
    
    /// The localized names for the pokemon's abilities.
    var pokemonAbilities: String {
        var abilityNames = [String]()
        for ability in abilities {
            let availableLanguageCodes = ability.names.map { name in
                name.language.name
            }
            let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguageCodes).first!
            let matchingAbility = ability.names.first { abilityName in
                abilityName.language.name == deviceLanguageCode
            }
            if let matchingAbility {
                abilityNames.append(matchingAbility.name)
            } else {
                abilityNames.append(ability.name)
            }
        }
        return ListFormatter.localizedString(byJoining: abilityNames)
    }
    
    /// The percentage chance for the male pokemon.
    var pokemonMaleGenderPercentage: Double {
        if pokemonSpecies == nil { return 0.0 }
        return 1 - pokemonfemaleGenderPercentage
    }
    /// The percentage chance for the female pokemon.
    var pokemonfemaleGenderPercentage: Double {
        guard let pokemonSpecies else { return 0.0 }
        return Double(pokemonSpecies.genderRate) / 8.0
    }
    
}

// MARK: - Public functions
extension AboutTabModel {
    /// Sets up the model.
    mutating func setUp() async {
        pokemonSpecies = await PokemonSpecies.fromName(name: pokemon.name)
        abilities = await getPokemonAbilities()
        await getEggGroups()
    }
}

// MARK: - Private functions
private extension AboutTabModel {
    /// Gets the abilities of this pokemon.
    mutating func getPokemonAbilities() async -> [Ability] {
        var abilities = [Ability]()
        for pokemonAbility in pokemon.abilities {
            guard let ability = await Ability.from(name: pokemonAbility.ability.name) else { continue }
            abilities.append(ability)
        }
        return abilities
    }
    
    /// Gets all the egg groups for this pokemon.
    mutating func getEggGroups() async {
        if pokemonSpecies == nil {
            return
        }
        for eggGroups in pokemonSpecies!.eggGroups {
            guard let group = await EggGroup.from(name: eggGroups.name) else {
                continue
            }
            self.eggGroups.append(group)
        }
    }
}
