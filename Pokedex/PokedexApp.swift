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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(imageCache)
                .environmentObject(settingsManager)
                .setSettings(settingsManager.settings)
        }
    }
}
