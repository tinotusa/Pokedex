//
//  Cache.swift
//  Pokedex
//
//  Created by Tino on 4/8/2022.
//

import Foundation

final class Cache<Key: Hashable, Value> {
    private var cache = NSCache<WrappedKey, Entry>()
    private var keyTracker = KeyTracker()

    init() {
        // Leaving it as unlimited because there is a limit to all the pokemon data
//        cache.countLimit = 0
        cache.delegate = keyTracker
    }
    
    func value(forKey key: Key) -> Value? {
        let entry = cache.object(forKey: WrappedKey(key: key))
        return entry?.value
    }
    
    func insert(_ value: Value, forKey key: Key) {
        let entry = Entry(key: key, value: value)
        cache.setObject(entry, forKey: WrappedKey(key: key))
        keyTracker.insert(key)
    }
    
    func removeValue(forKey key: Key) {
        cache.removeObject(forKey: WrappedKey(key: key))
    }
}

extension Cache {
    subscript(key: Key) -> Value? {
        get { value(forKey: key) }
        set {
            if let value = newValue {
                insert(value, forKey: key)
                return
            }
            // if newValue was nil remove the value for the key
            removeValue(forKey: key)
        }
    }
}

extension Cache {
    final class WrappedKey: NSObject {
        let key: Key
        
        init(key: Key) {
            self.key = key
        }
        
        override var hash: Int { return key.hashValue }
        
        override func isEqual(_ object: Any?) -> Bool {
            if let object = object as? WrappedKey {
                return object.key == key
            }
            return false
        }
    }
}

extension Cache {
    final class Entry {
        let key: Key
        let value: Value
        
        init(key: Key, value: Value) {
            self.key = key
            self.value = value
        }
    }
}

private extension Cache {
    final class KeyTracker: NSObject, NSCacheDelegate {
        var keys = Set<Key>()
        
        func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
            if let entry = obj as? Entry {
                keys.remove(entry.key)
                return
            }
        }
        
        func insert(_ key: Key) {
            keys.insert(key)
        }
    }
}

extension Cache.Entry: Codable where Key: Codable, Value: Codable { }

extension Cache: Codable where Key: Codable, Value: Codable {
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.singleValueContainer()
        let entries = try container.decode([Entry].self)
        entries.forEach(insert)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(keyTracker.keys.compactMap(entry))
    }
    
    func saveToDisk(withName name: String, using fileManager: FileManager = .default) throws {
        let folderURLs = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        let fileURL = folderURLs.first!.appendingPathComponent("\(name).cache")
        let data = try JSONEncoder().encode(self)
        try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
    }
    
    func loadFromDisk(fromName name: String, using fileManager: FileManager = .default) {
        let folderURLs = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        let fileURL = folderURLs.first!.appendingPathComponent("\(name).cache")
        let data = try? Data(contentsOf: fileURL)
        guard let data else { return }
        let decodedCache = try? JSONDecoder().decode(Self.self, from: data)
        if let decodedCache {
            print("Successfully loaded from disk")
            self.cache = decodedCache.cache
            self.keyTracker = decodedCache.keyTracker
            print("THe cache")
            print(self.cache)
            print("THE END OF THE CACHE")
            print(self.keyTracker)
            print("THE END OF THE KEYTRACKER")
        }
    }
}


private extension Cache {
    func entry(forKey key: Key) -> Entry? {
        if let entry = cache.object(forKey: WrappedKey(key: key)) {
            return entry
        }
        return nil
    }
    
    func insert(_ entry: Entry) {
        cache.setObject(entry, forKey: WrappedKey(key: entry.key))
        keyTracker.insert(entry.key)
    }
}
