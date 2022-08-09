//
//  SettingsViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 9/8/2022.
//

import Foundation

@MainActor
final class SettingsViewViewModel: ObservableObject {
    @Published var languages = [Language]()
    private let limit = 20
    
    init() {
        Task {
            let url = URL(string: "https://pokeapi.co/api/v2/language?limit=\(limit)&offset=0")!
            let resourceList = try? await PokeAPI.shared.getData(for: NamedAPIResourceList.self, url: url)
            guard let resourceList else { return }
            await withTaskGroup(of: Language?.self) { group in
                for result in resourceList.results {
                    group.addTask {
                        let language = await Language.from(name: result.name)
                        return language
                    }
                }
                var temp = [Language]()
                for await language in group {
                    if let language {
                        temp.append(language)
                    }
                }
                languages = temp.sorted()
            }
        }
    }
}
