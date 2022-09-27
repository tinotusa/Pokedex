//
//  DetailImage.swift
//  Pokedex
//
//  Created by Tino on 13/9/2022.
//

import SwiftUI

struct DetailImage: View {
    let url: URL?
    var size: Double = 320
    
    var body: some View {
        ImageLoaderView(url: url) {
            ProgressView()
        } content: { image in
            image
                .interpolation(.none)
                .resizable()
                .scaledToFit()
        }
        .frame(width: size, height: size)
    }
}

struct DetailImage_Previews: PreviewProvider {
    static var previews: some View {
        DetailImage(
            url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png")
        )
        .environmentObject(ImageCache())
    }
}
