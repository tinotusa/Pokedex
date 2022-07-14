//
//  PokeAPI.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import Foundation

final class PokeAPI: ObservableObject {
    let apiURL = URL(string: "https://pokeapi.co/api/v2")!
    var isCached: Bool
    
    init(isCached: Bool = true) {
        self.isCached = isCached
        if isCached {
            URLCache.shared.memoryCapacity = 1024 * 1024
            URLCache.shared.diskCapacity = 1024 * 1024 * 1024 * 1024
        }
    }
    
    func pokemon(named name: String) async -> Pokemon? {
        let name = name.lowercased()
        let pokemonURL = apiURL.appending(path: "pokemon/\(name)")
        let urlRequest = URLRequest(url: pokemonURL, cachePolicy: .returnCacheDataElseLoad)

        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
            let httpURLResponse = urlResponse as! HTTPURLResponse
            guard (200 ..< 299).contains(httpURLResponse.statusCode) else {
                let statusCode = httpURLResponse.statusCode
                print("Invalid server response code: \(statusCode)")
                return nil
            }
            
            let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
            return pokemon
        } catch {
            print("Error in \(#function)\n\(error)")
        }
        
        return nil
    }
}
