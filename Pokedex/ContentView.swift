//
//  ContentView.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        HomeView()
            .onChange(of: scenePhase) { scenePhase in
                if scenePhase == .inactive {
                    print("about to save")
                    PokeAPI.shared.saveCache()
                }
            }
            .environment(\.colorScheme, settingsManager.isDarkMode ? .dark : .light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ImageCache())
            .environmentObject(SettingsManager())
    }
}
