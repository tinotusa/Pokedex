//
//  PokeAPI.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import Foundation

final class PokeAPI: ObservableObject {
    let pokemonURL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    let pokemonSpeciesURL = URL(string: "https://pokeapi.co/api/v2/pokemon-species")!
    var isCached: Bool
    
    init(isCached: Bool = true) {
        self.isCached = isCached
        if isCached {
            URLCache.shared.memoryCapacity = 1024 * 1024
            URLCache.shared.diskCapacity = 1024 * 1024 * 1024 * 1024
        }
    }
    
    private func getData<T>(for type: T.Type, urlRequest: URLRequest) async -> T?
        where T: Codable
    {
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
            let httpURLResponse = urlResponse as! HTTPURLResponse
            guard (200 ..< 299).contains(httpURLResponse.statusCode) else {
                let statusCode = httpURLResponse.statusCode
                print("Invalid server response code: \(statusCode)")
                return nil
            }
            
            let decodedData = try JSONDecoder().decode(type, from: data)
            return decodedData
        } catch {
            print("Error in \(#function)\n\(error)")
        }
        
        return nil
    }
    
    func pokemonSpecies(named name: String) async -> PokemonSpecies? {
        let name = name.lowercased()
        let speciesURL = pokemonSpeciesURL.appending(path: name)
        let request = URLRequest(url: speciesURL, cachePolicy: .returnCacheDataElseLoad)
        return await getData(for: PokemonSpecies.self, urlRequest: request)
    }
    
    func pokemon(named name: String) async -> Pokemon? {
        let name = name.lowercased()
        let pokemonURL = pokemonURL.appending(path: name)
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
