//
//  MoveDamageClassDetailViewModel.swift
//  Pokedex
//
//  Created by Tino on 23/9/2022.
//

import SwiftUI
import os

final class MoveDamageClassDetailViewModel: ObservableObject {
    @Published private(set) var viewState = ViewState.loading
    
    private var settings: Settings?
    private var moveDamageClass: MoveDamageClass?
    private var logger = Logger(subsystem: "com.tinotusa.Pokedex", category: "MoveDamageClassDetailViewModel")
}

// MARK: - Public
extension MoveDamageClassDetailViewModel {
    func loadData(moveDamageClass: MoveDamageClass, settings: Settings) {
        setUp(moveDamageClass: moveDamageClass, settings: settings)
        
        viewState = .loaded
    }
}

// MARK: - Computed properties
extension MoveDamageClassDetailViewModel {
    var localizedDamageClassName: String {
        guard let settings else {
            logger.debug("Failed to get localized MoveDamageClass name. settings is nil.")
            return "Error"
        }
        guard let moveDamageClass else {
            logger.debug("Failed to get localized MoveDamageClass name. moveDamageClass is nil.")
            return "Error"
        }
        return moveDamageClass.names.localizedName(language: settings.language, default: moveDamageClass.name).localizedCapitalized
    }
    
    var localizedDescription: String {
        logger.debug("Starting to get localized description.")
        guard let settings else {
            logger.debug("Failed to get localized description. settings is nil.")
            return "Error"
        }
        guard let moveDamageClass else {
            logger.debug("Failed to get localized description. moveDamageClass is nil.")
            return "Error"
        }
        
        var description: Description?
        if let language = settings.language {
            logger.debug("Found localized description matching settings language: \(language.name).")
            description = moveDamageClass.descriptions.first { $0.language.name == language.name }
        }
        let availableLanguageCodes = moveDamageClass.descriptions.map { $0.language.name }
        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguageCodes, forPreferences: nil).first!
        if description == nil {
            logger.debug("Found localized description matching device language: \(deviceLanguageCode).")
            description = moveDamageClass.descriptions.first { $0.language.name == deviceLanguageCode }
        }
        
        if description == nil {
            logger.debug("Found localized description matching english.")
            description = moveDamageClass.descriptions.first { $0.language.name == "en" }
        }
        
        if let description {
            logger.debug("Found localized description.")
            return description.description
        }
        logger.debug("Failed to find localized description.")
        return "Error"
    }
}

// MARK: - Private
private extension MoveDamageClassDetailViewModel {
    func setUp(moveDamageClass: MoveDamageClass, settings: Settings) {
        self.moveDamageClass = moveDamageClass
        self.settings = settings
    }
}
