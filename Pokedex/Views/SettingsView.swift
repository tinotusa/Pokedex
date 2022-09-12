//
//  SettingsView.swift
//  Pokedex
//
//  Created by Tino on 19/8/2022.
//

import SwiftUI

final class SettingsViewViewModel: ObservableObject {
    @Published private(set) var settings = Settings.default
    @Published private(set) var viewState = ViewState.loading
    @Published private(set) var languages = [Language]()
    
    @MainActor
    func setUp(settings: Settings) async {
        self.settings = settings
        await getLanguages()
    }
    
    @MainActor
    private func getLanguages() async {
        guard let resourceList = try? await PokeAPI.shared.getResourceList(fromEndpoint: "language", limit: 100) else {
            return
        }
        for result in resourceList.results {
            guard let language = try? await Language.from(name: result.name) else {
                continue
            }
            self.languages.append(language)
        }
        viewState = .loaded
    }
}

struct SettingsView: View {
    @EnvironmentObject private var settingsManager: SettingsManager
    @StateObject private var viewModel = SettingsViewViewModel()
    
    var body: some View {
        VStack {
            PopoverNavigationBar()
            ScrollView {
                header
                
                switch viewModel.viewState {
                case .loading:
                    LoadingView(text: "Loading languages.")
                        .task {
                            await viewModel.setUp(settings: settingsManager.settings)
                        }
                case .loaded:
                    settingsList
                default:
                    Text("Empty view")
                }
            }
        }
        .bodyStyle()
        .padding()
        .foregroundColor(.textColour)
        .backgroundColour()
        .environment(\.colorScheme, settingsManager.isDarkMode ? .dark : .light)
    }
    
}

private extension SettingsView {
    var settingsList: some View {
        VStack {
            Toggle("Dark mode", isOn: $settingsManager.isDarkMode)
            Toggle("Should cache", isOn: $settingsManager.shouldCacheResults)
            HStack {
                Text("Language")
                Spacer()
                Picker("Language", selection: $settingsManager.language) {
                    Text("No selection")
                        .tag(nil as Language?)
                    ForEach(viewModel.languages) { language in
                        Text(language.localizedLanguageName)
                            .tag(language as Language?)
                    }
                }
                .pickerStyle(.menu)
            }
            Spacer()
        }
    }
    
    var header: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Settings")
                .headerStyle()
            Divider()
        }
    }
    
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsManager())
    }
}
