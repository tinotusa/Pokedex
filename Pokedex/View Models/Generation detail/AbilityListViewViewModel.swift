//
//  AbilityListViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 22/9/2022.
//

import Foundation
import os

final class AbilityListViewViewModel: ObservableObject {
    /// A sorted array of abilities.
    @Published private(set) var abilities = [Ability]()
    @Published private(set) var viewState = ViewState.loading
    @Published private(set) var hasNextPage = true
    
    private var logger = Logger(subsystem: "com.tinotusa.Pokedex", category: "AbilityListViewViewModel")
    
    private var settings: Settings?
    private var urls = [URL]()
    
    private var limit = 20
    private var offset = 0
    private var page = 0 {
        didSet {
            offset = page * limit
        }
    }
    
}

// MARK: - Public
extension AbilityListViewViewModel {
    @MainActor
    func loadData(urls: [URL], settings: Settings) async {
        logger.debug("Starting to load data from urls (\(urls.count))")
        setUp(urls: urls, settings: settings)
        let abilities = await getAbilities(from: urls).sorted()
        
        self.abilities = abilities
        
        if abilities.count < limit {
            logger.debug("Reached end of data.")
            hasNextPage = false
        }
        viewState = .loaded
        page += 1
        logger.debug("Successfully loaded the data from urls (\(urls.count))")
    }
    
    @MainActor
    func loadNextPage() async {
        logger.debug("Starting to load next abilities page. page \(self.page) offset: \(self.offset)")
        
        let abilities = await getNextAbilitiesPage().sorted()
        self.abilities.append(contentsOf: abilities)
        if abilities.count < limit {
            logger.debug("Reached end of abilities list.")
            hasNextPage = false
        }
        
        logger.debug("Successfully got next abilities page. total: \(self.abilities.count), Download count: \(abilities.count) hasNextPage: \(self.hasNextPage)")
        page += 1
    }
}

// MARK: - Private
private extension AbilityListViewViewModel {
    func getAbilities(from urls: [URL]) async -> [Ability] {
        logger.debug("Starting to download abilities from urls (\(urls.count))")
        
        let abilities = await withTaskGroup(of: Ability?.self) { group in
            for (i, url) in urls.enumerated() where i < limit {
                group.addTask { [weak self] in
                    do {
                        return try await Ability.from(url: url)
                    } catch {
                        self?.logger.debug("Failed to download ability from url: \(url).\n\(error)")
                    }
                    return nil
                }
            }
            var tempAbilities = [Ability]()
            for await ability in group {
                guard let ability else { continue }
                tempAbilities.append(ability)
            }
            return tempAbilities
        }
        
        logger.debug("Successfully downloaded abilities from urls (\(urls.count))")
        return abilities
    }
    
    func getNextAbilitiesPage() async -> [Ability] {
        logger.debug("Starting download for next abilities page.")
        
        let abilities = await withTaskGroup(of: Ability?.self) { group  in
            for (i, url) in urls.enumerated()
                where i >= offset && i < offset + limit
            {
                group.addTask { [weak self] in
                    do {
                        return try await Ability.from(url: url)
                    } catch {
                        self?.logger.debug("Failed to download ability from url: \(url).\n\(error)")
                    }
                    return nil
                }
            }
            
            var tempAbilities = [Ability]()
            for await ability in group {
                guard let ability else { continue }
                tempAbilities.append(ability)
            }
            return tempAbilities
        }
        
        logger.debug("Successfully download abilities. count: \(abilities.count)")
        return abilities
    }
    
    func setUp(urls: [URL], settings: Settings) {
        self.urls = urls
        self.settings = settings
    }
}
