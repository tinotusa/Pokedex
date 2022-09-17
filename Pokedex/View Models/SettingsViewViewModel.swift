//
//  SettingsViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 13/9/2022.
//

import Foundation

final class SettingsViewViewModel: ObservableObject {
    @Published private(set) var settings = Settings.default
    @Published private(set) var viewState = ViewState.loading
    @Published private(set) var languages = [Language]()
    @Published private(set) var cacheSize: UInt64 = 0
    @Published var showDeleteCacheConfirmation = false
}

extension SettingsViewViewModel {
    func deleteCache() {
        PokeAPI.shared.clearCache()
        cacheSize = 0
    }
    
    @MainActor
    func loadData(settings: Settings) async {
        setUp(settings: settings)
        await getLanguages()
        cacheSize = getCacheSize()
    }
}

private extension SettingsViewViewModel {
    func setUp(settings: Settings){
        self.settings = settings
    }
    
    func getCacheSize() -> UInt64 {
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let cacheFileURL = cacheDirectory.appendingPathComponent(PokeAPI.cacheFilename)
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: cacheFileURL.path)
            let size = fileAttributes[.size] as! UInt64
            return size
        } catch {
            print("reading size from: ", cacheFileURL)
            #if DEBUG
            print("Error in \(#function)\n\(error)")
            #endif
        }
        return 0
    }
    
    @MainActor
    private func getLanguages() async {
        guard let resourceList = try? await PokeAPI.shared.getResourceList(fromEndpoint: "language", limit: 100) else {
            viewState = .empty
            return
        }
        
        await withTaskGroup(of: Language?.self) { group in
            for result in resourceList.results {
                group.addTask {
                    do {
                        return try await Language.from(name: result.name)
                    } catch {
                        #if DEBUG
                        print("Error in \(#function).\n\(error)")
                        #endif
                    }
                    return nil
                }
            }
            
            var languages = [Language]()
            for await language in group {
                guard let language else { continue }
                languages.append(language)
            }
            self.languages = languages
        }
        viewState = .loaded
    }
}
