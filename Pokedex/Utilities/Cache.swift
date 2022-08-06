//
//  Cache.swift
//  Pokedex
//
//  Created by Tino on 4/8/2022.
//

import Foundation

final class Cache {
    private var values = [String: Data]()
    private var hasChanges = false
    
    private func sanitizeFilename(name: String) -> String {
        return name.replacingOccurrences(of: "/", with: "-")
    }
    
    init() {
        print("Cache init is called")
    }
    
    func get<T: Codable>(name: String, forType type: T.Type) -> T? {
        let filename = sanitizeFilename(name: name)
        // the file is not in memory
        if values[filename] == nil {
            // get file url
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = documentsDirectory.appendingPathComponent(filename)
            if !FileManager.default.fileExists(atPath: url.path()) {
                print("File name: \(filename) doesn't exist")
                return nil
            }
            do {
                let data = try Data(contentsOf: url)
                // add to values
                values[filename] = data
                
                // decode
                let decodedData = try JSONDecoder().decode(type, from: values[filename]!)
                
                // return value
                return decodedData
            } catch {
                print("Error in \(#function)\n\(error)")
            }
        }
        // It's already in memory
        do {
            let decodedData = try JSONDecoder().decode(type, from: values[filename]!)
            print("Getting data from filename: \(filename)")
            return decodedData
        } catch {
            print("Error in \(#function)\n\(error.localizedDescription)")
        }
        
        return nil
    }

    func insert(item: Cachable) {
        guard let data = item.getData() else { return }
        if values[item.filename] != nil { return }
        values[item.filename] = data
        hasChanges = true
    }

    func insert(filename: String, data: Data) {
        let filename = sanitizeFilename(name: filename)
        if values[filename] != nil { return }
        values[filename] = data
        print("added filename: \(filename) with data: \(data)")
        hasChanges = true
    }
    
    func remove(item: Cachable) {
        values[item.filename] = nil
        hasChanges = true
    }

    func save() {
        if !hasChanges { return }
        defer { hasChanges = false }
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        for (filename, value) in values {
            let url = documentsDirectory.appendingPathComponent(filename)
            do {
                if FileManager.default.fileExists(atPath: url.path()) {
                    print("Filename \(filename) already exists won't save again.")
                    continue
                }
                try value.write(to: url, options: [.atomic])
                print("SAVED filename: \(filename) with data: \(value)")
            } catch {
                print("Error in \(#function)\n\(error)")
            }
        }
    }
}
