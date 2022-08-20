//
//  ImageLoader.swift
//  Pokedex
//
//  Created by Tino on 4/8/2022.
//

import SwiftUI

final class ImageLoader: ObservableObject {
    @Published var cache: ImageCache?
    @Published var uiImage: UIImage?
    @Published var state = LoadingState.idle
    @Published var task: Task<Void, Never>?
    init(cache: ImageCache = ImageCache()) {
        self.cache = cache
    }
}

extension ImageLoader {
    enum LoadingState: Equatable {
        case idle, isLoading, finishedLoading, error(String)
    }
}

extension ImageLoader {
    @MainActor
    func getImage(url: URL?) async {
        if state == .isLoading { return }
        
        if let url, let image = cache?[url] {
            print("getting image")
            uiImage = image
            state = .finishedLoading
            return
        }
        
        await loadImage(url: url)
    }
    
    @MainActor
    private func loadImage(url: URL?) async {
        guard let url else { return }
        state = .isLoading
        do {
            let (data, urlResponse) = try await URLSession.shared.data(from: url)
            try Task.checkCancellation()
            if let urlResponse = urlResponse as? HTTPURLResponse,
               !(200 ..< 299).contains(urlResponse.statusCode)
            {
                print("Error in \(#function).\nInvalid status code: \(urlResponse.statusCode)")
                state = .error("Invalid status code: \(urlResponse.statusCode)")
                return
            }
            cache?[url] = UIImage(data: data)
            uiImage = cache?[url]
            state = .finishedLoading
            return
        } catch is CancellationError {
            print("Task cancelled in \(#function).")
        } catch {
            state = .error(error.localizedDescription)
            print("Error in \(#function).\n\(error)")
        }
        return
    }
}
