//
//  PokemonAboutTabViewModel.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

@MainActor
final class PokemonAboutTabViewModel: ObservableObject {
    @Published private var pokemon: Pokemon?
    @Published private(set) var pokemonSpecies: PokemonSpecies?
    @Published private(set) var generation: Generation?
    @Published private(set) var growthRate: GrowthRate?
    @Published private(set) var habitat: PokemonHabitat?
    @Published private(set) var pokedexNumbers = [(entryNumber: Int, pokedex: Pokedex)]()
    @Published private(set) var eggGroups = [EggGroup]()
    @Published private(set) var abilities = [Ability]()
    @Published private(set) var isLoading = false
    
    private var settings: Settings?
    
    init() { }
    
    func setUp(settings: Settings, pokemon: Pokemon) {
        self.settings = settings
        self.pokemon = pokemon
    }
    
    func loadData() async {
        defer {
            isLoading = false
            print("TASK: FIRST DEFER")
        }
        
        await withTaskGroup(of: Void.self) { group in
            guard let pokemon else {
                print("Error in \(#function) at \(#line).\nCalled function without pokemon being set.")
                return
            }
            isLoading = true
            print("TASK: 1")
            
            self.pokemonSpecies = try? await PokemonSpecies.from(name: pokemon.species.name)
            guard let pokemonSpecies = self.pokemonSpecies else {
                print("Errow in \(#function). Pokemon species is nil.")
                return
            }
            
            group.addTask { @MainActor [self] in
                generation = try? await Generation.from(name: pokemonSpecies.generation.name)
                print("TASK: 2")
            }
            
            group.addTask { @MainActor [self] in
                growthRate = try? await GrowthRate.from(name: pokemonSpecies.growthRate.name)
                print("TASK: 3")
            }
            
            group.addTask { @MainActor [self] in
                if let habitatResource = pokemonSpecies.habitat {
                    habitat = try? await PokemonHabitat.from(name: habitatResource.name)
                    print("TASK: 33")
                }
            }
            
            group.addTask { @MainActor [self] in
                eggGroups = await pokemonSpecies.eggGroups()
                print("TASK: 4")
            }
            
            group.addTask { @MainActor [self] in
                abilities = await getPokemonAbilities()
                print("TASK: 5")
            }
            
            for dexNumber in pokemonSpecies.pokedexNumbers {
                group.addTask { @MainActor [self] in
                    let pokedex = try? await Pokedex.from(name: dexNumber.pokedex.name)
                    if let pokedex {
                        pokedexNumbers.append((dexNumber.entryNumber, pokedex))
                    }
                }
            }
            print("TASK: END OF GROUP TASKS")
        }
        print("TASK: END OF function")
    }
}

// MARK: Computed properties
extension PokemonAboutTabViewModel {
    /// The localized name for the pokemon's generation.
    var localizedGenerationName: String {
        guard let settings else {
            print("Error in \(#function). Settings is nil.")
            return "Error"
        }
        guard let generation else {
            print("Error in \(#function). Generation is nil.")
            return "Error"
        }
        return generation.names.localizedName(language: settings.language, default: generation.name)
    }
    
    var generationName: String {
        guard let generation else {
            print("Error in \(#function). Generation is nil.")
            return "Error"
        }
        return generation.name
    }
    
    var pokemonHasHabitat: Bool {
        guard let pokemonSpecies else { return false }
        return pokemonSpecies.habitat != nil
    }
    
    var localizedHabitatName: String {
        guard let settings else {
            print("Error in \(#function). Settings are nil.")
            return "Error"
        }
        guard let habitat else {
            print("Error in \(#function). Habitat is nil.")
            return "Error"
        }
        return habitat.names.localizedName(language: settings.language, default: habitat.name).capitalized
    }
    
    var localizedGrowthRateName: String {
        guard let settings else {
            print("Error in \(#function). Settings are nil.")
            return "Error"
        }
        guard let growthRate else {
            print("Error in \(#function). Growth rate is nil.")
            return "Error"
        }
        let availableLanguages = growthRate.descriptions.map { description in
            description.language.name
        }
        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguages, forPreferences: nil).first!
        let description = growthRate.descriptions.first { description in
            description.language.name == settings.language?.name ?? deviceLanguageCode
        }
        if let description {
            return description.description.capitalized
        }
        return growthRate.name.capitalized
    }
    
    /// The localized seed type for the pokemon.
    var pokemonSeedType: String {
        guard let pokemonSpecies else {
            print("Error in \(#function) at: \(#line), Pokemon species is nil")
            return "Error"
        }
        
        return pokemonSpecies.seedType(language: settings?.language)
    }
    
    /// The localized names for the pokemons egg group.
    var eggGroupNames: [String] {
        eggGroups.map { eggGroup in
            eggGroup.names.localizedName(language: settings?.language, default: eggGroup.name)
        }
    }

    /// The number for the pokemon in the pokedex.
    var pokemonID: Int {
        pokemon?.id ?? 0
    }
    
    /// The pokemon's height in meters.
    var pokemonHeight: Double {
        Double(pokemon?.height ?? 0) / 10.0
    }
    
    /// The pokemon's weight in kilograms.
    var pokemonWeight: Double {
        Double(pokemon?.weight ?? 0) / 10.0
    }
    
    func localizedPokemonName(language: Language?) -> String {
        guard let pokemonSpecies else { return "Error" }
        guard let pokemon else { return "Error" }
        return pokemonSpecies.names.localizedName(language: language, default: pokemon.name)
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
private extension PokemonAboutTabViewModel {
    /// Gets the abilities of this pokemon.
    func getPokemonAbilities() async -> [Ability] {
        guard let pokemon else { return [] }
        var abilities = [Ability]()
        for pokemonAbility in pokemon.abilities {
            guard let ability = try? await Ability.from(name: pokemonAbility.ability.name) else { continue }
            abilities.append(ability)
        }
        return abilities
    }
}
