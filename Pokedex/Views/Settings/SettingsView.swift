//
//  SettingsView.swift
//  Pokedex
//
//  Created by Tino on 3/8/2022.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewViewModel()
    @AppStorage("appSettings") var appSettings = Data()
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        NavigationStack {
            Form {
                Toggle("Cache results", isOn: $settingsManager.shouldCacheResults)
                Picker("Language", selection: $settingsManager.language) {
                    Text("No selection").tag(nil as Language?)
                    ForEach(viewModel.languages) { language in
                        Text(language.localizedLanguageName)
                            .tag(language as Language?)
                    }
                }
                Toggle("Dark mode", isOn: $settingsManager.isDarkMode)
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsManager())
    }
}
