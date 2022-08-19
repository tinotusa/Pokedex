//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

@main
struct PokedexApp: App {
    @StateObject var imageLoader = ImageLoader()
    @StateObject var settingsManager = SettingsManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(imageLoader)
                .environmentObject(settingsManager)
                .setSettings(settingsManager.settings)
        }
    }
}
