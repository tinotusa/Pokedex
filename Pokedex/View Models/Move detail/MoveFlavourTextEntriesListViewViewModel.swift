//
//  MoveFlavourTextEntriesListViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 14/9/2022.
//

import Foundation

final class MoveFlavourTextEntriesListViewViewModel: ObservableObject {
    @Published private(set) var versionGroups = [VersionGroup]()
    @Published private(set) var versions = [Version]()
    @Published private(set) var viewState = ViewState.loading
    private var settings: Settings?
}

extension MoveFlavourTextEntriesListViewViewModel {
    @MainActor
    func loadData(settings: Settings, entries: [MoveFlavorText]) async {
        if entries.isEmpty {
            viewState = .empty
            return
        }
        self.settings = settings
        await loadVersionGroups(entries: entries)
        await loadVersions(versionGroups: self.versionGroups)
        viewState = .loaded
    }
    
    func localizedVersionName(for name: String) -> String {
        guard let versionGroup = versionGroups.first(where: { $0.name == name }) else { return "Error" }
        guard let version = versions.first(where: { $0.id == versionGroup.id }) else {
            return "Error"
        }
        return version.names.localizedName(language: settings?.language, default: version.name)
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
                group.addTask {
                    return try? await Version.from(id: versionGroup.id)
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
