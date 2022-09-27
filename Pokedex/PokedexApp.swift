//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

@main
struct PokedexApp: App {
    
    @StateObject private var imageCache = ImageCache()
    @StateObject private var settingsManager = SettingsManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(imageCache)
                .environmentObject(settingsManager)
        }
    }
}
