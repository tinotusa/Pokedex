//
//  GenerationDetailViewModel.swift
//  Pokedex
//
//  Created by Tino on 21/9/2022.
//

import SwiftUI
import os

final class GenerationDetailViewModel: ObservableObject {
    @Published private(set) var region: Region?
    @Published private(set) var viewState = ViewState.loading
    @Published private(set) var generationInfo = [GenerationInfo: String]()
    
    @Published private(set) var versionGroups = [VersionGroup]()
    @Published private var versions = [Version]()
    
    private var settings: Settings?
    private var generation: Generation?
    private var logger = Logger(subsystem: "com.tinotusa.Pokedex", category: "GenerationDetailViewModel")
}

extension GenerationDetailViewModel {
    enum GenerationInfo: String, CaseIterable, Identifiable {
        case abilities
        case mainRegion = "main region"
        case moves
        case pokemonSpecies = "pokemon species"
        case types
        case versionGroups = "version groups"
        
        var id: Self { self }
        
        var title: LocalizedStringKey {
            LocalizedStringKey(self.rawValue.localizedCapitalized)
        }
    }
    
    @MainActor
    func loadData(generation: Generation, settings: Settings) async {
        logger.debug("Getting data for generation with id: \(generation.id)")
        setUp(generation: generation, settings: settings)
        do {
            self.region = try await Region.from(name: generation.mainRegion.name)
        } catch {
            logger.debug("Failed to get region from generation with id: \(generation.id)")
        }
        let versionGroups = await getVersionGroups().sorted()
        let versions = await getVersions(from: versionGroups)
        
        self.versionGroups = versionGroups
        self.versions = versions
        
        getGenerationInfo()
        viewState = .loaded
        logger.debug("Successfully got data for generation with id: \(generation.id)")
    }
    
    func getGenerationInfo() {
        guard let generation else {
            logger.debug("Failed to get generation info. Generation is nil.")
            return
        }
        
        generationInfo[.abilities] = "\(generation.abilities.count)"
        generationInfo[.mainRegion] = localizedRegionName
        generationInfo[.moves] = "\(generation.moves.count)"
        generationInfo[.pokemonSpecies] = "\(generation.pokemonSpecies.count)"
        generationInfo[.types] = "\(generation.types.count)"
        generationInfo[.versionGroups] = "\(generation.versionGroups.count)"
        logger.debug("Successfully got generation info")
    }
    
    func getVersionGroups() async -> [VersionGroup] {
        logger.debug("Starting to downlod version groups")
        guard let generation else {
            logger.debug("Failed to downlod version groups. Generation is nil.")
            return []
        }
        
        let versionGroups = await withTaskGroup(of: VersionGroup?.self) { group in
            for versionGroup in generation.versionGroups {
                group.addTask { [weak self] in
                    do {
                        return try await VersionGroup.from(name: versionGroup.name)
                    } catch {
                        self?.logger.debug("Failed to download VersionGroup from name: \(versionGroup.name)")
                    }
                    return nil
                }
            }
            var tempGroups = [VersionGroup]()
            for await versionGroup in group {
                guard let versionGroup else { continue }
                tempGroups.append(versionGroup)
            }
            return tempGroups
        }
        
        logger.debug("Successfully download version groups. count: \(versionGroups.count)")
        return versionGroups
    }
    
    func getVersions(from versionGroups: [VersionGroup]) async -> [Version] {
        logger.debug("Starting download for versions from versionGroups.")
        if versionGroups.isEmpty {
            logger.debug("Failed to download. version groups is empty.")
            return []
        }
        
        let versions = await withTaskGroup(of: Version?.self) { group in
            for versionGroup in versionGroups {
                for version in versionGroup.versions {
                    group.addTask { [weak self] in
                        do {
                            return try await Version.from(name: version.name)
                        } catch {
                            self?.logger.debug("Failed to download version from VersionGroup version with name: \(version.name)")
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
        logger.debug("Successfully download versions \(versions.count) from version groups \(versionGroups.count)")
        return versions
    }
    
    
    func versions(withName name: String) -> [Version] {
        guard let versionGroup = self.versionGroups.first(where: { $0.name == name }) else {
            logger.debug("No version group with name \(name) found.")
            return []
        }
        return versions.filter { $0.versionGroup.name == versionGroup.name }
    }
}

// MARK: - Computed properties
extension GenerationDetailViewModel {
    var localizedGenerationName: String {
        guard let generation else {
            logger.debug("Failed to get generation name. Generation is nil.")
            return "Error"
        }
        return generation.names.localizedName(language: settings?.language, default: generation.name)
    }
    
    var localizedRegionName: String {
        guard let region else {
            logger.debug("Failed to get localized region name. Region is nil.")
            return "Error"
        }
        guard let settings else {
            logger.debug("Failed to get localized region name. Settings is nil.")
            return "Error"
        }
        return region.names.localizedName(language: settings.language, default: region.name)
    }
}

private extension GenerationDetailViewModel {
    func setUp(generation: Generation, settings: Settings) {
        self.generation = generation
        self.settings = settings
    }
}
