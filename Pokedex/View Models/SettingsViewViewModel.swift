//
//  SettingsViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 13/9/2022.
//

import Foundation

final class SettingsViewViewModel: ObservableObject {
    @Published private(set) var settings = Settings.default
    @Published private(set) var viewState = ViewState.loading
    @Published private(set) var languages = [Language]()
}

extension SettingsViewViewModel {
    @MainActor
    func setUp(settings: Settings) async {
        self.settings = settings
        await getLanguages()
    }
    
    @MainActor
    private func getLanguages() async {
        guard let resourceList = try? await PokeAPI.shared.getResourceList(fromEndpoint: "language", limit: 100) else {
            viewState = .empty
            return
        }
        
        for result in resourceList.results {
            do {
                let language = try await Language.from(name: result.name)
                self.languages.append(language)
            } catch {
                #if DEBUG
                print("Error in \(#function).\n\(error)")
                #endif
            }
        }
        viewState = .loaded
    }
}
