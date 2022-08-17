//
//  PokemonCard.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

struct PokemonCard: View {
    let pokemon: Pokemon
    @State private var localizedPokemonName = ""
    @State private var typeNames = [String]()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        VStack(spacing: 0) {
            PokemonImage(url: pokemon.officialArtWork, imageSize: Constants.imageSize)
            VStack(alignment: .leading) {
                Text(localizedPokemonName)
                    .bodyStyle()
                HStack {
                    ForEach(pokemon.types, id: \.self) { type in
                        PokemonTypeTag(name: type.type.name)
                    }
                    Spacer()

                }
            }
        }
        .overlay(alignment: .topLeading) {
            Text(String(format: "#%03d", pokemon.id))
        }
        .padding()
        .foregroundColor(.textColour)
        .background {
            Color.white
        }
        .cornerRadius(Constants.backgroundCornerRadius)
        .shadow(radius: 3)
        .task {
            localizedPokemonName = await pokemon.localizedName()
            typeNames = pokemon.getTypes()
        }
    }
}

private extension PokemonCard {
    enum Constants {
        static let backgroundOpacity = 0.5
        static let backgroundCornerRadius = 30.0
        static let backgroundHeightPercentage = 0.6
        static let imageSize = 150.0
    }
}

struct PokemonRow_Previews: PreviewProvider {
    static let pokemon = Pokemon.example
    
    static var previews: some View {
        PokemonCard(pokemon: pokemon)
            .environmentObject(ImageLoader())
    }
}
