//
//  IconImage.swift
//  Pokedex
//
//  Created by Tino on 14/9/2022.
//

import SwiftUI

struct IconImage: View {
    let url: URL?
    
    var body: some View {
        ImageLoaderView(url: url) {
            ProgressView()
        } content: { image in
            image
                .interpolation(.none)
                .resizable()
                .scaledToFit()
        }
        .frame(width: 80, height: 80)
    }
}

struct IconImage_Previews: PreviewProvider {
    static var previews: some View {
        IconImage(
            url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")!
        )
        .environmentObject(ImageCache())
    }
}
