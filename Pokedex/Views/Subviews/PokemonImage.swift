//
//  PokemonImage.swift
//  Pokedex
//
//  Created by Tino on 1/8/2022.
//

import SwiftUI

struct PokemonImage: View {
    let url: URL?
    let imageSize: Double
    
    init(url: URL?, imageSize: Double = 150) {
        self.url = url
        self.imageSize = imageSize
    }
    
    var body: some View {
        ImageLoaderView(url: url) {
            ProgressView()
        } content: { image in
            image
                .resizable()
                .scaledToFit()
        }
        .frame(width: imageSize, height: imageSize)
    }
}

struct PokemonImage_Previews: PreviewProvider {
    static var previews: some View {
        PokemonImage(url: URL(string: "omegalul.com/test.png"))
            .environmentObject(ImageCache())
    }
}
