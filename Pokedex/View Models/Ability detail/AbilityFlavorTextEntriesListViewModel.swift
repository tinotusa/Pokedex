//
//  AbilityFlavorTextEntriesListViewModel.swift
//  Pokedex
//
//  Created by Tino on 17/9/2022.
//

import Foundation
import os

final class AbilityFlavorTextEntriesListViewModel: ObservableObject {
    @Published private var versions = [Version]()
    @Published private var versionGroups = [VersionGroup]()
    @Published private(set) var viewState = ViewState.loading
    
    private var settings: Settings?
    private var entries = [AbilityFlavorText]()
    private var logger = Logger(subsystem: "com.tinotusa.Pokedex", category: "AbilityFlavorTextEntireslistViewModel")
}

extension AbilityFlavorTextEntriesListViewModel {
    @MainActor
    func loadData(entries: [AbilityFlavorText], settings: Settings) async {
        setUp(entries: entries, settings: settings)
        guard !entries.isEmpty else {
            viewState = .empty
            logger.debug("No entries to list")
            return
        }
        
        let versionGroups = await getVersionGroups(entries: entries)
        self.versionGroups = versionGroups
        self.versions = await getVersions(versionGroups: versionGroups)
        viewState = .loaded
    }
    
    func getLocalizedVersionName(for name: String) -> [String] {
        let versionGroup = versionGroups.first { $0.name == name }
        guard let versionGroup else {
            logger.error("Failed to find version group with matching name: \(name)")
            return []
        }
        let versions = versions.filter { $0.versionGroup.name == versionGroup.name }
        guard !versions.isEmpty else {
            logger.error("Failed to find versions with matching name: \(versionGroup.name)")
            return []
        }
        
        return versions.map { $0.names.localizedName(language: settings?.language, default: $0.name) }
    }
}

private extension AbilityFlavorTextEntriesListViewModel {
    func setUp(entries: [AbilityFlavorText], settings: Settings) {
        self.entries = entries
        self.settings = settings
    }
    
    func getVersionGroups(entries: [AbilityFlavorText]) async -> [VersionGroup] {
        await withTaskGroup(of: VersionGroup?.self) { group in
            for entry in entries {
                group.addTask { [weak self] in
                    do {
                        return try await VersionGroup.from(name: entry.versionGroup.name)
                    } catch {
                        self?.logger.error("Failed to get version group from url: \(entry.versionGroup.url)")
                    }
                    return nil
                }
            }
            var tempVersionGroups = [VersionGroup]()
            for await versionGroup in group {
                guard let versionGroup else { continue }
                tempVersionGroups.append(versionGroup)
            }
            logger.debug("Successfully got version groups")
            return tempVersionGroups
        }
    }
    
    func getVersions(versionGroups: [VersionGroup]) async -> [Version] {
        await withTaskGroup(of: Version?.self) { group in
            for versionGroup in versionGroups {
                for version in versionGroup.versions {
                    group.addTask { [weak self] in
                        do {
                            return try await Version.from(url: version.url)
                        } catch {
                            self?.logger.error("Failed to get version from url: \(version.url)")
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
            logger.debug("Successfully got versions")
            return tempVersions
        }
    }
}
