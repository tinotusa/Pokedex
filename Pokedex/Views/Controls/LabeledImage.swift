//
//  LabeledImage.swift
//  Pokedex
//
//  Created by Tino on 2/9/2022.
//

import SwiftUI

struct LabeledImage: View {
    var imageURL: URL?
    var label: String
    var imageSize: Double
    
    var body: some View {
        HStack {
            ImageLoaderView(url: imageURL) {
                ProgressView()
            } content: { image in
                image
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: imageSize, height: imageSize)
            
            Text(label)
                .foregroundColor(.gray)
        }
        .bodyStyle()
        .foregroundColor(.textColour)
    }
}

struct LabeledImage_Previews: PreviewProvider {
    static var previews: some View {
        LabeledImage(
            imageURL: Item.example.sprites.default,
            label: "Item",
            imageSize: 60.0
        )
        .environmentObject(ImageCache())
    }
}
