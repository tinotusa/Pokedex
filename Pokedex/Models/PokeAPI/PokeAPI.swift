//
//  PokeAPI.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import Foundation

final class PokeAPI: ObservableObject {
    static let apiURL = "https://pokeapi.co/api/v2/"
    
    static let shared = PokeAPI()
    private var cache = Cache()
    
    func saveCache() {
        cache.save()
    }
    
    var shouldCacheResults = false
    
    private init() {
        print("PokeAPI Init called")
    }
    
    enum PokeAPIError: Error {
        case invalidEndPoint
        case failedToGetHTTPURLResponse
        case invalidResponseStatusCode(code: Int)
        case failedToDecode
        case other(error: Error)
    }
    
    func getData<T>(for type: T.Type, fromEndpoint endpoint: String) async throws -> T
    where T: Codable
    {
        guard let url = URL(string: "\(Self.apiURL)/\(endpoint)") else {
            throw PokeAPIError.invalidEndPoint
        }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)

        if let cachedResult = cache.get(name: endpoint, forType: type) {
            return cachedResult
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error in \(#function)\nFailed to get http url response")
                throw PokeAPIError.failedToGetHTTPURLResponse
            }
            guard (200 ..< 299).contains(httpResponse.statusCode) else {
                print("Error server status code: \(httpResponse.statusCode). From endpoint: \(endpoint)")
                throw PokeAPIError.invalidResponseStatusCode(code: httpResponse.statusCode)
            }
            let decodedData = try JSONDecoder().decode(type, from: data)
            
            cache.insert(filename: endpoint, data: data)
            return decodedData
            
        } catch {
            print(error)
            throw PokeAPIError.other(error: error)
        }
    }
    
    func getData<T>(for type: T.Type, url: URL) async throws -> T
        where T: Codable
    {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        let filename = url.absoluteString
        if let cachedResult = cache.get(name: filename, forType: type) {
            return cachedResult
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error in \(#function)\nFailed to get http url response")
                throw PokeAPIError.failedToGetHTTPURLResponse
            }
            guard (200 ..< 299).contains(httpResponse.statusCode) else {
                print("Error server status code: \(httpResponse.statusCode)")
                throw PokeAPIError.invalidResponseStatusCode(code: httpResponse.statusCode)
            }
            let decodedData = try JSONDecoder().decode(type, from: data)
            
            cache.insert(filename: filename, data: data)
            return decodedData
        } catch {
            print(error)
            throw PokeAPIError.other(error: error)
        }
    }
}
