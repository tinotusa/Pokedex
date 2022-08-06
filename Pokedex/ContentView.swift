//
//  ContentView.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @Environment(\.scenePhase) var scenePhase
    enum Tab {
        case home
        case settings
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
