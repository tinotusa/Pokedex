//
//  ImageLoader.swift
//  Pokedex
//
//  Created by Tino on 4/8/2022.
//

import SwiftUI

final class ImageLoader: ObservableObject {
    private var cache = Cache<URL, Data>()
    
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
            if let urlResponse = urlResponse as? HTTPURLResponse,
               !(200 ..< 299).contains(urlResponse.statusCode)
            {
                print("Error in \(#function).\nInvalid status code: \(urlResponse.statusCode)")
                return nil
            }
            cache[url] = data
            return cache[url]
        } catch {
            print(error)
        }
        return nil
    }
}
