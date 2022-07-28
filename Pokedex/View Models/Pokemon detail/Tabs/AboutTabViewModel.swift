//
//  AboutTabViewModel.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

final class AboutTabViewModel: ObservableObject {
    @Published var model: AboutTabModel
    
    init(pokemon: Pokemon) {
        model = AboutTabModel(pokemon: pokemon)
    }
    
    @MainActor
    func setUp() async {
        await model.setUp()
    }
    
    var pokemonSeedType: String {
        model.pokemonSeedType
    }
    
    var eggGroupNames: String {
        model.eggGroupNames
    }

    var pokemonID: Int {
        model.pokemonID
    }

    var pokemonHeight: Double {
        model.pokemonHeight
    }
    
    var pokemonWeight: Double {
        model.pokemonWeight
    }
    
    var pokemonAbilities: String {
        model.pokemonAbilities
    }
    
    var pokemonMaleGenderPercentage: Double {
        model.pokemonMaleGenderPercentage
    }
    
    var pokemonFemaleGenderPercentage: Double {
        model.pokemonfemaleGenderPercentage
    }
    
    var pokemonDescription: String {
        guard let species = model.pokemonSpecies else {
            return "Error"
        }
        let availableLanguages = species.flavorTextEntries.map { entry in
            entry.language.name
        }
        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguages).first!
        let matchedEntry = species.flavorTextEntries.first { entry in
            entry.language.name == deviceLanguageCode
        }
        if let matchedEntry {
            return matchedEntry.flavorText
        }
        return "No description available."
    }
}
