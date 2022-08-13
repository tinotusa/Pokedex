//
//  ImageLoaderView.swift
//  Pokedex
//
//  Created by Tino on 4/8/2022.
//

import SwiftUI

struct ImageLoaderView<Content: View, PlaceholderContent: View>: View {
    @EnvironmentObject var imageLoader: ImageLoader
    @State private var image: UIImage?
    @State private var data: Data?
    
    private let url: URL?
    private let placeholder: () -> PlaceholderContent
    private let content: (Image) -> Content
    
    init(url: URL?,
         @ViewBuilder placeholder: @escaping () -> PlaceholderContent,
         @ViewBuilder content: @escaping ((Image) -> Content)
    ) {
        self.url = url
        self.placeholder = placeholder
        self.content = content
    }
    
    var body: some View {
        VStack {
            if imageLoader.state == .loading {
                placeholder()
            } else if imageLoader.state == .loaded {
                if let uiImage = image, let image = Image(uiImage: uiImage) {
                    content(image)
                }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundColor(.red.opacity(0.5))
                    Text("Failed to load image.")
                        .foregroundColor(.textColour)
                }
            }
        }
        .task {
            data = await imageLoader.getImage(url: url)
            if let data {
                image = UIImage(data: data)
            }
        }
    }
}

struct ImageLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        ImageLoaderView(
            url: URL(string: "https://en.wikipedia.org/wiki/Tree#/media/File:Ash_Tree_-_geograph.org.uk_-_590710.jpg"))
        {
            ProgressView()
        } content: { image in
            image
                .resizable()
                .scaledToFit()
        }
        .environmentObject(ImageLoader())
    }
}
