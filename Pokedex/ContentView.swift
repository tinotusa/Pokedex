//
//  ContentView.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

final class ContentViewViewModel: ObservableObject {
    @Published var settings: Settings?
    @Published var settingsManager: SettingsManager?
    
    @MainActor
    func setUp(settingsManager: SettingsManager) {
        self.settingsManager = settingsManager
    }
    
    var isDarkMode: Bool {
        guard let settings = settingsManager?.settings else {
            return false
        }
        return settings.isDarkMode
    }
}

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.appSettings) var appSettings
    @StateObject var viewModel = ContentViewViewModel()
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        SearchView()
            .onChange(of: scenePhase) { scenePhase in
                if scenePhase == .inactive {
                    print("about to save")
                    PokeAPI.shared.saveCache()
                }
            }
            .task {
                viewModel.setUp(settingsManager: settingsManager)
            }
            .environment(\.colorScheme, appSettings.isDarkMode ? .dark : .light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SettingsManager())
            .environmentObject(ImageLoader())
    }
}
