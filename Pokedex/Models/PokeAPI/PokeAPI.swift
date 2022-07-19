//
//  PokeAPI.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import Foundation

final class PokeAPI: ObservableObject {
    enum PokeAPIEndpoint {
        case pokemon
        case species
        case types
        case eggGroups
        case ability

        var url: URL {
            switch self {
            case .pokemon: return URL(string: "https://pokeapi.co/api/v2/pokemon")!
            case .species: return URL(string: "https://pokeapi.co/api/v2/pokemon-species")!
            case .types: return URL(string: "https://pokeapi.co/api/v2/type")!
            case .eggGroups: return URL(string: "https://pokeapi.co/api/v2/egg-group")!
            case .ability: return URL(string: "https://pokeapi.co/api/v2/ability")!
            }
        }
    }
    
    let isCached: Bool
    
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
    
    func ability(named name: String) async -> Ability? {
        let name = name.lowercased()
        let url = PokeAPIEndpoint.ability.url.appending(path: name)
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        return await getData(for: Ability.self, urlRequest: request)
    }
    
    func eggGroups(named name: String) async -> EggGroups? {
        let name = name.lowercased()
        let eggGroupsURL = PokeAPIEndpoint.eggGroups.url.appending(path: name)
        let request = URLRequest(url: eggGroupsURL, cachePolicy: .returnCacheDataElseLoad)
        return await getData(for: EggGroups.self, urlRequest: request)
    }
    
    func pokemonType(named name: String) async -> PokemonType? {
        let name = name.lowercased()
        let typeURL = PokeAPIEndpoint.types.url.appending(path: name)
        let request = URLRequest(url: typeURL, cachePolicy: .returnCacheDataElseLoad)
        return await getData(for: PokemonType.self, urlRequest: request)
    }
    
    func pokemonSpecies(named name: String) async -> PokemonSpecies? {
        let name = name.lowercased()
        let speciesURL = PokeAPIEndpoint.species.url.appending(path: name)
        let request = URLRequest(url: speciesURL, cachePolicy: .returnCacheDataElseLoad)
        return await getData(for: PokemonSpecies.self, urlRequest: request)
    }
    
    func pokemon(named name: String) async -> Pokemon? {
        let name = name.lowercased()
        let pokemonURL = PokeAPIEndpoint.pokemon.url.appending(path: name)
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
