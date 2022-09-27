//
//  AbilityEffectChangesViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 23/9/2022.
//

import Foundation
import os

final class AbilityEffectChangesViewViewModel: ObservableObject {
    @Published private(set) var viewState = ViewState.loading
    @Published private(set) var versions = [Version]()
    @Published private(set) var versionGroups = [VersionGroup]()
//    @Published private(set) var localizedEffectEntries = [Effect]()
    
    private var settings: Settings?
    private var abilityEffectChanges = [AbilityEffectChange]()
    
    private var logger = Logger(subsystem: "com.tinotusa.Pokedex", category: "AbilityEffectChangesViewViewModel")
}

// MARK: - Computed properties
extension AbilityEffectChangesViewViewModel {
    
}

// MARK: - Public
extension AbilityEffectChangesViewViewModel {
    func loadData(abilityEffectChanges: [AbilityEffectChange], settings: Settings) async {
        logger.debug("Loading data for ability effect changes.")
        setUp(abilityEffectChanges: abilityEffectChanges, settings: settings)
    
        let versionGroups = await getVersionGroups().sorted()
        let versions = await getVersions(from: versionGroups)
        
        self.versionGroups = versionGroups
        self.versions = versions
        
        viewState = .loaded
        logger.debug("Successfully loaded data for ability effect changes.")
    }
    
    func localizedVersionGroupName(for versionGroupName: String) -> [String] {
        logger.debug("Gettings localized version group names from version group with name: \(versionGroupName)")
        guard let settings else {
            logger.debug("Failed to get localized version group names. settings is nil.")
            return []
        }
        
        let versions = versions.filter { $0.versionGroup.name == versionGroupName}
        
        logger.debug("Successfully got localized version group names for version group with name: \(versionGroupName)")
        return versions.map { $0.names.localizedName(language: settings.language, default: $0.name)}
    }
    
    func localizedEffectEntry(for effectEntries: [Effect]) -> String {
        logger.debug("Starting to get localized effect entry")
        guard let settings else {
            logger.debug("Failed to get localized effect entry. settings is nil.")
            return "Error"
        }
        return effectEntries.localizedEffectName(language: settings.language, default: "Error")
    }
}

// MARK: - Private
private extension AbilityEffectChangesViewViewModel {
    func setUp(abilityEffectChanges: [AbilityEffectChange], settings: Settings) {
        self.abilityEffectChanges = abilityEffectChanges
        self.settings = settings
    }
    
    func getVersionGroups() async -> [VersionGroup] {
        logger.debug("Started getVersionGroups.")
        if abilityEffectChanges.isEmpty {
            logger.debug("Failed to get VersionGroups. abilityEffectChanges is empty.")
            return []
        }
        let versionGroups = await withTaskGroup(of: VersionGroup?.self) { group in
            for abilityEffectChange in abilityEffectChanges {
                group.addTask { [weak self] in
                    do {
                        return try await VersionGroup.from(name: abilityEffectChange.versionGroup.name)
                    } catch {
                        self?.logger.debug("Failed to get VersionGroup from name: \(abilityEffectChange.versionGroup.name)")
                    }
                    return nil
                }
            }
            
            var tempGroups = [VersionGroup]()
            for await versionGroup in group {
                guard let versionGroup else {
                    continue
                }
                tempGroups.append(versionGroup)
            }
            return tempGroups
        }
        logger.debug("Successfully got versions. count: \(versionGroups.count).")
        return versionGroups
    }
    
    func getVersions(from versionGroups: [VersionGroup]) async -> [Version] {
        logger.debug("Started getVersions.")
        let versions = await withTaskGroup(of: Version?.self) { group in
            for versionGroup in versionGroups {
                for version in versionGroup.versions {
                    group.addTask { [weak self] in
                        do {
                            return try await Version.from(name: version.name)
                        } catch {
                            self?.logger.debug("Failed to get Version from name: \(version.name)")
                        }
                        return nil
                    }
                }
            }
            var tempVersions = [Version]()
            for await version in group {
                guard let version else { continue }
                tempVersions.append(version)
            }
            return tempVersions
        }
        logger.debug("Successfully got Version. count: \(versions.count).")
        return versions
    }
    
//    func getLocalizedEffectEntries() -> [Effect] {
//        logger.debug("Starting to get locaclized effect entries.")
//        guard let settings else {
//            logger.debug("Failed to get locaclized effect entries. settings is nil.")
//            return []
//        }
//        var effectEntries = []()
//        for abilityEffect in abilityEffectChanges {
//            effectEntries.append(abilityEffect.effectEntries.localizedEffectName(language: settings.language, default: "Error"))
//        }
//    }
}
