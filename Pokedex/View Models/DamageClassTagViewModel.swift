//
//  DamageClassTagViewModel.swift
//  Pokedex
//
//  Created by Tino on 11/9/2022.
//

import Foundation

final class DamageClassTagViewModel: ObservableObject {
    @Published private(set) var viewState = ViewState.loading
    @Published private(set) var damageClass: MoveDamageClass?
    private var settings: Settings?
}

extension DamageClassTagViewModel {
    @MainActor
    func load(name: String, settings: Settings) async {
        self.settings = settings
        
        do {
            damageClass = try await MoveDamageClass.from(name: name)
            viewState = .loaded
        } catch {
            #if DEBUG
            print("Error in \(#function).\n\(error)")
            #endif
            viewState = .error(error)
        }
    }
    
    var localizedDamageClassName: String {
        guard let damageClass else { return "Error" }
        guard let settings else { return "Error" }
        return damageClass.names.localizedName(language: settings.language, default: damageClass.name)
    }
}
