//
//  ImageLoader.swift
//  Pokedex
//
//  Created by Tino on 4/8/2022.
//

import SwiftUI

// TODO: - Consider caching the images aswell (either use cache or look into implementing a NSCache subclass)
final class ImageLoader: ObservableObject {
    private var cache = [URL: Data]()
    
    init() {
        
    }
    
    func getImage(url: URL?) async -> Data? {
        if let url, let image = cache[url] {
            print("getting image")
            return image
        }
        return await loadImage(url: url)
    }
    
    private func loadImage(url: URL?) async -> Data? {
        guard let url else { return nil }
        do {
            let (data, urlResponse) = try await URLSession.shared.data(from: url)
            cache[url] = data
            return cache[url]
        } catch {
            print(error)
        }
        return nil
    }
}
