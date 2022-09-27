//
//  GenerationTagViewModel.swift
//  Pokedex
//
//  Created by Tino on 11/9/2022.
//

import Foundation

final class GenerationTagViewModel: ObservableObject {
    @Published var generation: Generation?
    @Published var viewState = ViewState.loading
    private var settings: Settings?
}

extension GenerationTagViewModel {
    
    @MainActor
    func load(name: String, settings: Settings) async {
        self.settings = settings
        
        do {
            generation = try await Generation.from(name: name)
            viewState = .loaded
        } catch {
            #if DEBUG
            print("Error in \(#function).\n\(error)")
            #endif
            viewState = .error(error)
        }
    }
    
    var localizedGenerationName: String {
        guard let generation else { return "Error" }
        guard let settings else { return "Error" }
        return generation.names.localizedName(language: settings.language, default: generation.name)
    }
}
