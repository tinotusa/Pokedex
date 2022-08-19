//
//  ImageCache.swift
//  Pokedex
//
//  Created by Tino on 19/8/2022.
//

import SwiftUI

/// An in memory cache for images.
struct ImageCache {
    /// The cache for the images.
    private let cache = NSCache<NSURL, UIImage>()
    
    /// Creats a new empty `ImageCache`
    ///
    ///     let imageCache = ImageCache() // uses the default config
    ///
    /// - parameter config: The settings for the cache.
    init(config: Config = .default) {
        cache.countLimit = config.countLimit
        cache.totalCostLimit = config.totalCostLimit
    }
    
    /// Returns a `UIImage` for the given key.
    ///
    /// - parameter key: The key (`URL`) for a value (`UIImage`) in the cache.
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set {
            if newValue == nil {
                cache.removeObject(forKey: key as NSURL)
                return
            }
            cache.setObject(newValue!, forKey: key as NSURL)
        }
    }
}

extension ImageCache {
    /// The settings for `ImageCache`.
    struct Config {
        /// The max number of items for the cache.
        /// Cache will start deleting item if the number is exeeded.
        let countLimit: Int
        /// The total size for the cache in MB.
        let totalCostLimit: Int
        /// A default Config with a `countLimit` of 100 and `totalCostLimit` of 100MB.
        static let `default` = Config(
            countLimit: 100,
            totalCostLimit: 1024 * 1024 * 100
        )
    }
}

