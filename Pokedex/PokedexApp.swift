//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

@main
struct PokedexApp: App {
    @StateObject var imageCache = ImageCache()
    @StateObject var settingsManager = SettingsManager()
    @StateObject var pokemonGridViewViewModel = PokemonGridViewViewModel()
    @StateObject var itemGridViewViewModel = ItemGridViewViewModel()
    @StateObject var moveGridViewViewModel = MoveGridViewViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(imageCache)
                .environmentObject(settingsManager)
                .environmentObject(pokemonGridViewViewModel)
                .environmentObject(itemGridViewViewModel)
                .environmentObject(moveGridViewViewModel)
                .setSettings(settingsManager.settings)
        }
    }
}
