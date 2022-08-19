//
//  TempSettingsView.swift
//  Pokedex
//
//  Created by Tino on 19/8/2022.
//

import SwiftUI

struct TempSettingsView: View {
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        Form {
            Toggle("Dark mode", isOn: $settingsManager.isDarkMode)
            Toggle("Should cache", isOn: $settingsManager.shouldCacheResults)
            Picker("Langauge", selection: $settingsManager.language) {
                Text("No selection")
                    .tag(nil as Language?)
                ForEach(languages) { language in
                    Text(language.localizedLanguageName)
                        .tag(language as Language?)
                }
            }
        }
        .setSettings(settingsManager.settings)
        .task {
            await getLanguages()
        }
    }
    
    @State private var languages = [Language]()
    func getLanguages() async {
        guard let resourceList = try? await PokeAPI.shared.getResourceList(fromEndpoint: "language", limit: 100) else {
            return
        }
        for result in resourceList.results {
            guard let language = await Language.from(name: result.name) else {
                continue
            }
            self.languages.append(language)
        }
    }
}

struct TempSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TempSettingsView()
            .environmentObject(SettingsManager())
    }
}
