//
//  PokeAPI.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import Foundation

final class PokeAPI: ObservableObject {
    static let apiURL = "https://pokeapi.co/api/v2/"
    static let cacheFilename = "PokeAPIResults"
    static let shared = PokeAPI()
    private let cache = Cache<String, Data>()
    
    private init() {
        print("PokeAPI Init called")
        cache.loadFromDisk(fromName: Self.cacheFilename)
    }
    
    func saveCache() {
        if shouldCacheResults {
            print("About to save to the cache")
            try? cache.saveToDisk(withName: Self.cacheFilename)
        }
    }
    
    var shouldCacheResults = true {
        didSet {
            print("changed shouldCacheResults to \(shouldCacheResults)")
        }
    }
    
    enum PokeAPIError: Error {
        case invalidEndPoint
        case failedToGetHTTPURLResponse
        case invalidResponseStatusCode(code: Int)
        case failedToDecode
        case other(error: Error)
    }
    
    private func sanitizeFilename(name: String) -> String {
        return name.replacingOccurrences(of: "/", with: "-")
    }
    
    func getData<T>(for type: T.Type, fromEndpoint endpoint: String) async throws -> T
    where T: Codable
    {
        guard let url = URL(string: "\(Self.apiURL)/\(endpoint)") else {
            throw PokeAPIError.invalidEndPoint
        }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        let endpoint = sanitizeFilename(name: endpoint)
        print("About to get from \(endpoint)")
        if let cachedData = cache.value(forKey: endpoint) {
            print("getting from the cache 1")
            return try JSONDecoder().decode(type, from: cachedData)
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
            if shouldCacheResults {
                print("adding \(endpoint) to the cache 1")
                cache.insert(data, forKey: endpoint)
            }
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
        let filename = sanitizeFilename(name: url.absoluteString)
        
        if let cachedResult = cache.value(forKey: filename) {
            print("getting from the cache 2")
            return try JSONDecoder().decode(type, from: cachedResult)
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
            if shouldCacheResults {
                print("adding to the cache 2")
                cache.insert(data, forKey: filename)
            }
            return decodedData
        } catch {
            print(error)
            throw PokeAPIError.other(error: error)
        }
    }
}
