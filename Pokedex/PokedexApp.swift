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
    @StateObject var homePokemonTabViewModel = HomePokemonTabViewModel()
    @StateObject var homeItemsTabViewModel = HomeItemsTabViewModel()
    @StateObject var homeMovesTabViewModel = HomeMovesTabViewModel()
    @StateObject var homeAbilitiesTabViewModel = HomeAbilitiesTabViewModel()
    @StateObject var searchBarViewModel = SearchBarViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(imageCache)
                .environmentObject(settingsManager)
                .environmentObject(homePokemonTabViewModel)
                .environmentObject(homeItemsTabViewModel)
                .environmentObject(homeMovesTabViewModel)
                .environmentObject(homeAbilitiesTabViewModel)
                .environmentObject(searchBarViewModel)
                .setSettings(settingsManager.settings)
        }
    }
}
