//
//  PokeAPI.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import Foundation

final class PokeAPI: ObservableObject {
    static let apiURL = "https://pokeapi.co/api/v2/"
    
    enum PokeAPIError: Error {
        case invalidEndPoint
        case failedToGetHTTPURLResponse
        case invalidResponseStatusCode(code: Int)
        case failedToDecode
        case other(error: Error)
    }
    
    static func getData<T>(for: T.Type, fromEndpoint endpoint: String) async throws -> T
        where T: Decodable
    {
        guard let url = URL(string: "\(Self.apiURL)/\(endpoint)") else {
            throw PokeAPIError.invalidEndPoint
        }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
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
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print(error)
            throw PokeAPIError.other(error: error)
        }
    }
    
    static func getData<T>(for: T.Type, url: URL) async throws -> T
        where T: Decodable
    {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
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
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print(error)
            throw PokeAPIError.other(error: error)
        }
    }
}
