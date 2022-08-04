//
//  Cache.swift
//  Pokedex
//
//  Created by Tino on 4/8/2022.
//

import Foundation

final class Cache {
    private var values = [String: Data]()
    
    init() {
        load()
    }
    func sanitizeFilename(name: String) -> String {
        return name.replacingOccurrences(of: "/", with: "-")
    }
    
    func get<T: Codable>(name: String, forType type: T.Type) -> T? {
        let name = sanitizeFilename(name: name)
        guard let itemData = values[name] else {
            return nil
        }
        do {
            let decodedData = try JSONDecoder().decode(type, from: itemData)
            print("Getting data from filename: \(name)")
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
        save()
    }

    func insert(filename: String, data: Data) {
        let filename = sanitizeFilename(name: filename)
        if values[filename] != nil { return }
        values[filename] = data
        print("added filename: \(filename) with data: \(data)")
        save()
    }
    
    func remove(item: Cachable) {
        values[item.filename] = nil
    }

    func load() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            for url in contents {
                let itemURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)
                let data = try Data(contentsOf: itemURL)
                values[url.lastPathComponent] = data
                print("LOADED filename: \(url.lastPathComponent) with data: \(data)")
            }
        } catch {
            print("error: \(error)")
        }
    }

    func save() {
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
