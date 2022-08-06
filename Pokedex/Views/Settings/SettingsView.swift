//
//  SettingsView.swift
//  Pokedex
//
//  Created by Tino on 3/8/2022.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var languages = [Language]()
    @Published var language: Language?
    @Published var shouldCacheResults = true
    @Published var isDarkMode = false
    private let limit = 20
    
    init() {
        Task {
            let url = URL(string: "https://pokeapi.co/api/v2/language?limit=\(limit)&offset=0")!
            let resourceList = try? await PokeAPI.shared.getData(for: NamedAPIResourceList.self, url: url)
            guard let resourceList else { return }
            await withTaskGroup(of: Language?.self) { group in
                for result in resourceList.results {
                    group.addTask {
                        let language = await Language.from(name: result.name)
                        return language
                    }
                }
                var temp = [Language]()
                for await language in group {
                    if let language {
                        temp.append(language)
                    }
                }
                languages = temp.sorted()
            }
        }
    }
    
    var languageName: String {
        language?.name ?? ""
    }
}

struct Settings: Codable {
    var shouldCacheResults = true
    var langauge: Language
    var isDarkMode = false
}

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()
    @AppStorage("shouldCacheResults") var shouldCacheResults = true
    @AppStorage("language") var language = ""
    @AppStorage("isDarkMode") var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            Form {
                Toggle("Cache results", isOn: $viewModel.shouldCacheResults)
                Picker("Language", selection: $viewModel.language) {
                    Text("No selection").tag(nil as Language?)
                    ForEach(viewModel.languages) { language in
                        Text(language.localizedLanguageName)
                            .tag(language as Language?)
                    }
                }
                Toggle("Dark mode", isOn: $isDarkMode)
            }
            .onChange(of: viewModel.shouldCacheResults) { shouldCache in
                shouldCacheResults = shouldCache
            }
            .onChange(of: viewModel.languageName) { name in
                self.language = name
            }
            .navigationTitle("Settings")
        }
        .task {
            viewModel.shouldCacheResults = shouldCacheResults
            viewModel.language = await Language.from(name: language)
//            if let language {
//                viewModel.language = language
//            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
