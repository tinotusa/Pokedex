//
//  Bundle+loadJSON.swift
//  Pokedex
//
//  Created by Tino on 20/8/2022.
//

import Foundation

extension Bundle {
    enum LoadJSONError: Error, LocalizedError {
        case noFileFound
        case dataDecodingError(Error)
    }
    
    func loadJSON<T>(ofType type: T.Type, filename: String, extension: String? = nil) throws -> T
        where T: Codable
    {
        guard let fileURL = Bundle.main.url(forResource: filename, withExtension: `extension`) else {
            throw LoadJSONError.noFileFound
        }
        
        do {
            let fileData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(type, from: fileData)
        } catch {
            throw LoadJSONError.dataDecodingError(error)
        }
    }
}
