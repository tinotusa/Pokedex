//
//  ImageLoaderView.swift
//  Pokedex
//
//  Created by Tino on 4/8/2022.
//

import SwiftUI

struct ImageLoaderView<Content: View, PlaceholderContent: View>: View {
    @EnvironmentObject private var imageCache: ImageCache
    @StateObject private var imageLoader = ImageLoader()
    
    private let url: URL?
    private let placeholder: () -> PlaceholderContent
    private let content: (Image) -> Content
    
    init(
        url: URL?,
        @ViewBuilder placeholder: @escaping () -> PlaceholderContent,
        @ViewBuilder content: @escaping (Image) -> Content
    ) {
        self.url = url
        self.placeholder = placeholder
        self.content = content
    }
    
    var body: some View {
        VStack {
            switch imageLoader.state {
            case .idle, .isLoading:
                placeholder()
            case .finishedLoading:
                if let uiImage = imageLoader.uiImage {
                    content(Image(uiImage: uiImage))
                }
            case .error(_):
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundColor(.red)
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
        }
        .task {
            imageLoader.cache = imageCache
            await imageLoader.getImage(url: url)
        }
//        .onDisappear {
//            print("Image disappeared: image was \(imageLoader.uiImage)")
//        }
    }
}

struct ImageLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        ImageLoaderView(url: nil) {
            ProgressView()
        } content: { image in
            image
                .resizable()
                .scaledToFit()
        }
        .environmentObject(ImageCache())
    }
}
