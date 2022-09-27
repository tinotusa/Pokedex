//
//  MoveDamageClassTagViewModel.swift
//  Pokedex
//
//  Created by Tino on 11/9/2022.
//

import Foundation
import os

final class MoveDamageClassTagViewModel: ObservableObject {
    @Published private(set) var viewState = ViewState.loading
    @Published private(set) var moveDamageClass: MoveDamageClass?
    
    private var settings: Settings?
    private var logger = Logger(subsystem: "com.tinotusa.Pokedex", category: "MoveDamageClassTagViewModel")
}

extension MoveDamageClassTagViewModel {
    @MainActor
    func load(name: String, settings: Settings) async {
        logger.debug("Starting load function with name: \(name), and settings: \(settings).")
        self.settings = settings
        
        do {
            moveDamageClass = try await MoveDamageClass.from(name: name)
            viewState = .loaded
            logger.debug("Successfully loaded with name: \(name), and settings: \(settings).")
        } catch {
            logger.error("Failed to load move damage class.\(error).")
            viewState = .error(error)
        }
    }
    
    var localizedDamageClassName: String {
        logger.debug("Getting localized move damage class name for moveDamageClass.")
        guard let moveDamageClass else {
            logger.debug("Failed to get localized move damage class name. moveDamageClass is nil.")
            return "Error"
        }
        guard let settings else {
            logger.debug("Failed to get localized move damage class name. setting is nil.")
            return "Error"
        }
        logger.debug("Successfully got  localized move damage class name for moveDamageClass id: \(moveDamageClass.id).")
        return moveDamageClass.names.localizedName(language: settings.language, default: moveDamageClass.name).localizedCapitalized
    }
}
