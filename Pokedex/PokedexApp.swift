//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

@main
struct PokedexApp: App {
    
    // MARK: - Managers
    @StateObject var imageCache = ImageCache()
    @StateObject var settingsManager = SettingsManager()
    
    // MARK: - View Models
    @StateObject var pokemonGridViewViewModel = PokemonGridViewViewModel()
    @StateObject var itemGridViewViewModel = ItemGridViewViewModel()
    @StateObject var moveGridViewViewModel = MoveGridViewViewModel()
    @StateObject var abilityListViewViewModel = AbilityListViewViewModel()
    @StateObject var searchBarViewModel = SearchBarViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(imageCache)
                .environmentObject(settingsManager)
                .environmentObject(pokemonGridViewViewModel)
                .environmentObject(itemGridViewViewModel)
                .environmentObject(moveGridViewViewModel)
                .environmentObject(abilityListViewViewModel)
                .environmentObject(searchBarViewModel)
                .setSettings(settingsManager.settings)
        }
    }
}
