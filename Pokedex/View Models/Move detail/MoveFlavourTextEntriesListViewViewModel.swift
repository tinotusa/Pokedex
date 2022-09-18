//
//  MoveFlavourTextEntriesListViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 14/9/2022.
//

import Foundation
import os

final class MoveFlavourTextEntriesListViewViewModel: ObservableObject {
    @Published private(set) var versionGroups = [VersionGroup]()
    @Published private(set) var versions = [Version]()
    @Published private(set) var viewState = ViewState.loading
    private var settings: Settings?
    private var logger = Logger(subsystem: "com.tinotusa.Pokedex", category: "MoveFlavorTextEntriesListViewViewModel")
}

extension MoveFlavourTextEntriesListViewViewModel {
    @MainActor
    func loadData(settings: Settings, entries: [MoveFlavorText]) async {
        logger.debug("Started loading data.")
        if entries.isEmpty {
            viewState = .empty
            logger.debug("Stopped loading data. No Entries given.")
            return
        }
        
        self.settings = settings
        await loadVersionGroups(entries: entries)
        await loadVersions(versionGroups: self.versionGroups)
        viewState = .loaded
        logger.debug("Successfully loaded data.")
    }
    
    func localizedVersionNames(for name: String) -> [String] {
        guard let versionGroup = versionGroups.first(where: { $0.name == name }) else {
            logger.debug("Failed to find version group with name: \(name).")
            return []
        }
        let versions = versions.filter { $0.versionGroup.name == versionGroup.name }
        
        logger.debug("Successfully got localized version names for: \(name).")
        return versions.map { $0.names.localizedName(language: settings?.language, default: $0.name) }
    }
}

private extension MoveFlavourTextEntriesListViewViewModel {
    @MainActor
    func loadVersionGroups(entries: [MoveFlavorText]) async {
        await withTaskGroup(of: VersionGroup?.self) { group in
            for entry in entries {
                group.addTask {
                    do {
                        return try await VersionGroup.from(name: entry.versionGroup.name)
                    } catch {
                        print(error)
                    }
                    return nil
                    
                }
            }
            var tempVersions = [VersionGroup]()
            for await version in group {
                guard let version else { continue }
                tempVersions.append(version)
            }
            self.versionGroups = tempVersions
        }
    }
    
    @MainActor
    func loadVersions(versionGroups: [VersionGroup]) async {
        if versionGroups.isEmpty { return }
        
        await withTaskGroup(of: Version?.self) { group in
            for versionGroup in versionGroups {
                for version in versionGroup.versions {
                    group.addTask { [weak self] in
                        do {
                            return try await Version.from(name: version.name)
                        } catch {
                            self?.logger.error("Failed to get version with name: \(version.name)")
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
            self.versions.append(contentsOf: tempVersions)
        }
    }
}
