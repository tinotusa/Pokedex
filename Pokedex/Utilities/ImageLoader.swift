//
//  ImageLoader.swift
//  Pokedex
//
//  Created by Tino on 4/8/2022.
//

import SwiftUI

final class ImageLoader: ObservableObject {
    private var cache = Cache<URL, Data>()
    @Published var state = LoadingState.loading
}

extension ImageLoader {
    enum LoadingState: Equatable {
        case loading, loaded, error(String)
    }
}

extension ImageLoader {
    @MainActor
    func getImage(url: URL?) async -> Data? {
        state = .loading
        if let url, let image = cache[url] {
            print("getting image")
            state = .loaded
            return image
        }
        return await loadImage(url: url)
    }
    
    @MainActor
    private func loadImage(url: URL?) async -> Data? {
        guard let url else { return nil }
        state = .loading
        do {
            let (data, urlResponse) = try await URLSession.shared.data(from: url)
            if let urlResponse = urlResponse as? HTTPURLResponse,
               !(200 ..< 299).contains(urlResponse.statusCode)
            {
                print("Error in \(#function).\nInvalid status code: \(urlResponse.statusCode)")
                state = .error("Invalid status code: \(urlResponse.statusCode)")
                return nil
            }
            cache[url] = data
            state = .loaded
            return cache[url]
        } catch {
            state = .error(error.localizedDescription)
            print(error)
        }
        state = .error("Unknown error")
        return nil
    }
}
