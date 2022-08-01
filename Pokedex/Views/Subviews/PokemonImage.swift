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
        AsyncImage(url: url) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if let _ = phase.error {
                ZStack {
                    Color.red
                    Text("Error")
                        .foregroundColor(.textColour)
                }
            } else {
                ProgressView()
            }
        }
        .frame(width: imageSize, height: imageSize)
    }
}

struct PokemonImage_Previews: PreviewProvider {
    static var previews: some View {
        PokemonImage(url: URL(string: "omegalul.com/test.png"))
    }
}
