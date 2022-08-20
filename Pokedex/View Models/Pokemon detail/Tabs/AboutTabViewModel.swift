//
//  AboutTabViewModel.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

@MainActor
final class AboutTabViewModel: ObservableObject {
    @Published private var pokemon: Pokemon
    @Published private(set) var pokemonSpecies: PokemonSpecies?
    @Published private(set) var eggGroups = [EggGroup]()
    @Published private(set) var abilities = [Ability]()
    private var settings: Settings?
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        Task {
            pokemonSpecies = try? await PokemonSpecies.from(name: pokemon.name)
            abilities = await getPokemonAbilities()
            eggGroups = await pokemonSpecies?.eggGroups() ?? []
        }
    }
    
    func setUp(settings: Settings) {
        self.settings = settings
    }
}

// MARK: Computed properties
extension AboutTabViewModel {
    var pokemonSeedType: String {
        guard let pokemonSpecies else {
            print("Error in \(#function) at: \(#line), Pokemon species is nil")
            return "Error"
        }
        
        return pokemonSpecies.seedType(language: settings?.language)
    }
    
    /// The localized names for the pokemons egg group.
    var eggGroupNames: String {
        var names = [String]()
        for eggGroup in eggGroups {
            let name = eggGroup.names.localizedName(language: settings?.language, default: eggGroup.name)
            names.append(name)
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
        guard let settings else {
            print("Error in \(#function) at line: \(#line). Settings is nil.")
            return "Error"
        }
        for ability in abilities {
            let name = ability.names.localizedName(language: settings.language, default: ability.name)
            abilityNames.append(name)
        }
        return ListFormatter.localizedString(byJoining: abilityNames)
    }
    
    /// The percentage chance for the male pokemon.
    var pokemonMaleGenderPercentage: Double {
        if pokemonSpecies == nil { return 0.0 }
        return 1 - pokemonFemaleGenderPercentage
    }
    
    /// The percentage chance for the female pokemon.
    var pokemonFemaleGenderPercentage: Double {
        guard let pokemonSpecies else { return 0.0 }
        return Double(pokemonSpecies.genderRate) / 8.0
    }
    
    var pokemonDescription: String {
        guard let species = pokemonSpecies else {
            return "Error"
        }
        let availableLangaugeCodes = species.flavorTextEntries.map { entry in
            entry.language.name
        }
        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLangaugeCodes, forPreferences: nil).first!
        var flavorText = species.flavorTextEntries.first { entry in
            if let settings = settings, let language = settings.language {
                return entry.language.name == language.name
            }
            return false
        }
        if flavorText == nil {
            flavorText = species.flavorTextEntries.first { entry in
                entry.language.name == deviceLanguageCode
            }
        }
        return flavorText?.flavorText ?? "No description found."
    }
}

// MARK: Private functions
private extension AboutTabViewModel {
    /// Gets the abilities of this pokemon.
    func getPokemonAbilities() async -> [Ability] {
        var abilities = [Ability]()
        for pokemonAbility in pokemon.abilities {
            guard let ability = try? await Ability.from(name: pokemonAbility.ability.name) else { continue }
            abilities.append(ability)
        }
        return abilities
    }
}
