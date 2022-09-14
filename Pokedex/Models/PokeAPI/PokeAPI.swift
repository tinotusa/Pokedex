//
//  PokeAPI.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import Foundation

final class PokeAPI: ObservableObject {
    static let apiURL = "https://pokeapi.co/api/v2/"
    static let apiURLScheme = "https"
    static let hostName = "pokeapi.co"
    static let pathName = "/api/v2"
    static let cacheFilename = "PokeAPIResults"
    static let shared = PokeAPI()
    private let cache = Cache<String, Data>()
    private let decoder: JSONDecoder
    private init() {
        print("PokeAPI Init called")
//        cache.loadFromDisk(fromName: Self.cacheFilename)
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    var shouldCacheResults = true {
        didSet {
            print("changed shouldCacheResults to \(shouldCacheResults)")
        }
    }
}

extension PokeAPI {
    enum PokeAPIError: Error {
        case invalidEndPoint
        case failedToGetHTTPURLResponse
        case invalidResponseStatusCode(code: Int)
        case failedToDecode
        case other(message: String)
    }
}

extension PokeAPI {
    func getResourceList(
        fromEndpoint endpoint: String,
        limit: Int
    )
        async throws -> NamedAPIResourceList
    {
        var urlComponents = URLComponents()
        urlComponents.scheme = Self.apiURLScheme
        urlComponents.host = Self.hostName
        urlComponents.path = "\(Self.pathName)/\(endpoint)"
        urlComponents.queryItems = [
            .init(name: "limit", value: "\(limit)"),
            .init(name: "offset", value: "0")
        ]
        guard let url = urlComponents.url else {
            print("Error in \(#function). Failed to create url from components")
            throw PokeAPIError.invalidEndPoint
        }
        do {
            let resourceList = try await getData(for: NamedAPIResourceList.self, url: url)
            return resourceList
        } catch {
            print("Error in \(#function).")
            throw PokeAPIError.other(message: error.localizedDescription)
        }
    }
    
    func saveCache() {
        if !shouldCacheResults { return }
        print("About to save to the cache")
        do {
            try cache.saveToDisk(withName: Self.cacheFilename)
        } catch {
            #if DEBUG
            print("Error in \(#function).\n\(error)")
            #endif
        }
    }
    
    func clearCache() {
        cache.clearCache(name: Self.cacheFilename)
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
        let request = URLRequest(url: url)
        let endpoint = sanitizeFilename(name: endpoint)
        print("About to get from \(endpoint)")
        if let cachedData = cache[endpoint] {
            print("getting from the cache 1")
            return try decoder.decode(type, from: cachedData)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            try Task.checkCancellation()
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error in \(#function)\nFailed to get http url response")
                throw PokeAPIError.failedToGetHTTPURLResponse
            }
            guard (200 ..< 299).contains(httpResponse.statusCode) else {
                print("Error server status code: \(httpResponse.statusCode). From endpoint: \(endpoint)")
                throw PokeAPIError.invalidResponseStatusCode(code: httpResponse.statusCode)
            }
            let decodedData = try decoder.decode(type, from: data)
            if shouldCacheResults {
                print("adding \(endpoint) to the cache 1")
                cache[endpoint] = data
            }
            return decodedData
            
        } catch is CancellationError {
            throw PokeAPIError.other(message: "Task cancelled")
        } catch {
            print("Error in \(#function).\n\(error)")
            throw PokeAPIError.other(message: error.localizedDescription)
        }
    }
    
    func getData<T>(for type: T.Type, url: URL) async throws -> T
        where T: Codable
    {
        let request = URLRequest(url: url)
        let filename = sanitizeFilename(name: url.absoluteString)
        
        if let cachedResult = cache[filename] {
            print("getting from the cache 2")
            return try decoder.decode(type, from: cachedResult)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            try Task.checkCancellation()
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error in \(#function)\nFailed to get http url response")
                throw PokeAPIError.failedToGetHTTPURLResponse
            }
            guard (200 ..< 299).contains(httpResponse.statusCode) else {
                print("Error server status code: \(httpResponse.statusCode)")
                throw PokeAPIError.invalidResponseStatusCode(code: httpResponse.statusCode)
            }
            let decodedData = try decoder.decode(type, from: data)
            if shouldCacheResults {
                print("adding to the cache 2")
                cache[filename] = data
            }
            return decodedData
        } catch {
            print(error)
            throw PokeAPIError.other(message: error.localizedDescription)
        }
    }
    
    func getItems<T>(ofType type: T.Type, from resourceList: NamedAPIResourceList) async -> (Set<T>, URL?)
        where T: Codable & SearchByName
    {
        var items = Set<T>()
        await withTaskGroup(of: T?.self) { group in
            for resource in resourceList.results {
                group.addTask {
                    let item = try? await T.from(name: resource.name)
                    return item as? T
                }
            }
            
            for await item in group {
                if let item {
                    items.insert(item)
                }
            }
        }
        return (items, resourceList.next)
    }
}
