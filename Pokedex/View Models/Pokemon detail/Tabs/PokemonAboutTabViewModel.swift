//
//  PokemonAboutTabViewModel.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

final class PokemonAboutTabViewModel: ObservableObject {
    @Published private(set) var pokemon: Pokemon?
    @Published private(set) var pokemonSpecies: PokemonSpecies?
    @Published private(set) var generation: Generation?
    @Published private(set) var growthRate: GrowthRate?
    @Published private(set) var habitat: PokemonHabitat?
    @Published private(set) var pokedexNumbers = [(entryNumber: Int, pokedex: Pokedex)]()
    @Published private(set) var eggGroups = [EggGroup]()
    @Published private(set) var abilities = [Ability]()
    @Published private(set) var viewState = ViewState.loading
    @Published private(set) var pokemonInfo = [PokemonInfo: String]()
    @Published private(set) var showingPokedexEntryNumbers = false
    private var settings: Settings?
}

extension PokemonAboutTabViewModel {
    @MainActor
    func loadData(settings: Settings, pokemon: Pokemon) async {
        setUp(settings: settings, pokemon: pokemon)
        
        defer {
            getPokemonInfo()
            viewState = .loaded
        }
        
        await withTaskGroup(of: Void.self) { group in
            self.pokemonSpecies = try? await PokemonSpecies.from(name: pokemon.species.name)
            guard let pokemonSpecies = self.pokemonSpecies else {
                print("Errow in \(#function). Pokemon species is nil.")
                return
            }
            
            group.addTask { @MainActor [self] in
                generation = try? await Generation.from(name: pokemonSpecies.generation.name)
            }
            
            group.addTask { @MainActor [self] in
                growthRate = try? await GrowthRate.from(name: pokemonSpecies.growthRate.name)
            }
            
            group.addTask { @MainActor [self] in
                if let habitatResource = pokemonSpecies.habitat {
                    habitat = try? await PokemonHabitat.from(name: habitatResource.name)
                }
            }
            
            group.addTask { @MainActor [self] in
                eggGroups = await pokemonSpecies.eggGroups()
            }
            
            group.addTask { @MainActor [self] in
                abilities = await getPokemonAbilities()
            }
            
            for dexNumber in pokemonSpecies.pokedexNumbers {
                group.addTask { @MainActor [self] in
                    let pokedex = try? await Pokedex.from(name: dexNumber.pokedex.name)
                    if let pokedex {
                        pokedexNumbers.append((dexNumber.entryNumber, pokedex))
                    }
                }
            }
        }
    }
    
    enum PokemonInfo: String, CaseIterable, Identifiable {
        case generation
        case type
        case abilities
        case eggGroups = "egg groups"
        case height
        case weight
        case gender
        case genus
        case captureRate = "capture rate"
        case baseHappiness = "base happiness"
        case growthRate = "growth rate"
        case habitat
        case legendary
        case mythical
        case pokedexEntryNumbers = "Entry numbers"
        
        var id: Self { self }
        
        var title: LocalizedStringKey {
            LocalizedStringKey(self.rawValue.localizedCapitalized)
        }
    }
    
    func showPokedexEntryNumbers() {
        withAnimation {
            showingPokedexEntryNumbers.toggle()
        }
    }
    
    var genderRatePercentages: AttributedString {
        guard let pokemonSpecies else { return "" }
        if pokemonSpecies.genderRate == -1 {
            return "No gender"
        }
        var str = AttributedString("♂ \(pokemonMaleGenderPercentage.formatted(.percent)) ♀ \(pokemonFemaleGenderPercentage.formatted(.percent))")
        let maleRange = str.range(of: "♂")!
        let femaleRange = str.range(of: "♀")!
        str[maleRange].foregroundColor = .blue
        str[femaleRange].foregroundColor = .pink
        return str
    }
    
    func getPokemonInfo() {
        guard let pokemon else { return }
        guard let pokemonSpecies else { return }
        pokemonInfo[.generation] = pokemonSpecies.generation.name
        pokemonInfo[.type] = "\(pokemon.types.count) types"
        pokemonInfo[.abilities] = "\(pokemon.abilities)"
        pokemonInfo[.eggGroups] = "\(pokemonSpecies.eggGroups.count) groups"
        pokemonInfo[.height] = Measurement(value: pokemon.heightInMeters, unit: UnitLength.meters).formatted()
        pokemonInfo[.weight] = Measurement(value: pokemon.weightInKilograms, unit: UnitMass.kilograms).formatted()
        pokemonInfo[.gender] = "\(pokemonSpecies.genderRate)"
        pokemonInfo[.genus] = pokemonSeedType
        if let captureRate = pokemonSpecies.captureRate {
            pokemonInfo[.captureRate] = "\(captureRate)"
        } else {
            pokemonInfo[.captureRate] = "N/A"
        }
        if let baseHappiness = pokemonSpecies.baseHappiness {
            pokemonInfo[.baseHappiness] = "\(baseHappiness)"
        } else {
            pokemonInfo[.baseHappiness] = "N/A"
        }
        
        pokemonInfo[.growthRate] = localizedGrowthRateName
        pokemonInfo[.habitat] = localizedHabitatName
        pokemonInfo[.legendary] = pokemonSpecies.isLegendary ? "Yes" : "No"
        pokemonInfo[.mythical] = pokemonSpecies.isMythical ? "Yes" : "No"
        pokemonInfo[.pokedexEntryNumbers] = "\(pokemonSpecies.pokedexNumbers.count) entries"
    }
    
    func localizedAbilityName(ability: Ability) -> String {
        ability.names.localizedName(language: settings?.language, default: ability.name)
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

    var localizedPokemonName: String {
        guard let pokemonSpecies else { return "Error" }
        guard let pokemon else { return "Error" }
        return pokemonSpecies.names.localizedName(language: settings?.language, default: pokemon.name)
    }
    
    /// The localized array of names for the pokemon's abilities.
    var pokemonAbilities: [String] {
        var abilityNames = [String]()
        guard let settings else {
            #if DEBUG
            print("Error in \(#function) at line: \(#line). Settings is nil.")
            #endif
            return []
        }
        for ability in abilities {
            let name = ability.names.localizedName(language: settings.language, default: ability.name)
            abilityNames.append(name)
        }
        return abilityNames
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
        guard let pokemonSpecies = pokemonSpecies else {
            return "Error"
        }
        return pokemonSpecies.flavorTextEntries.localizedFlavorText(language: settings?.language, default: "No flavor text.")
    }
}

// MARK: Private functions
private extension PokemonAboutTabViewModel {
    private func setUp(settings: Settings, pokemon: Pokemon) {
        self.settings = settings
        self.pokemon = pokemon
    }
    
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
