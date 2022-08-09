//
//  ContentView.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

enum Tab {
    case home
    case settings
}

// TODO: This doesn't work (saving appstorage doesn't update the view)
final class ContentViewViewModel: ObservableObject {
    @Published var selectedTab: Tab = .home
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
    @StateObject var viewModel = ContentViewViewModel()
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            HomeView()
                .tag(Tab.home)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            SettingsView()
                .tag(Tab.settings)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .onChange(of: scenePhase) { scenePhase in
            if scenePhase == .inactive {
                print("about to save")
                PokeAPI.shared.saveCache()
            }
        }
        .task {
            viewModel.setUp(settingsManager: settingsManager)
        }
        .environment(\.colorScheme, viewModel.isDarkMode ? .dark : .light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SettingsManager())
    }
}
