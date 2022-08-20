//
//  Bundle+loadJSON.swift
//  Pokedex
//
//  Created by Tino on 20/8/2022.
//

import Foundation

extension Bundle {
    enum LoadJSONError: Error, LocalizedError {
        case noFileFound(filename: String)
        case dataDecodingError(error: Error)
    }
    
    func loadJSON<T>(ofType type: T.Type, filename: String, extension: String? = nil) throws -> T
        where T: Codable
    {
        guard let fileURL = Bundle.main.url(forResource: filename, withExtension: `extension`) else {
            throw LoadJSONError.noFileFound(filename: filename)
        }
        
        do {
            let fileData = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode(type, from: fileData)
        } catch {
            throw LoadJSONError.dataDecodingError(error: error)
        }
    }
}
