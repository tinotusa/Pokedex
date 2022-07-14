//
//  PokemonRow.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

/// A small rounded rectangle with the name and colour of the pokemon's type.
struct PokemonTypeTag: View {
    let pokemonType: PokemonType
    
    var body: some View {
        Text(pokemonType.type.name.capitalized)
            .padding(.horizontal)
            .background(pokemonType.colour)
            .cornerRadius(14)
    }
}

struct PokemonRow: View {
    let pokemon: Pokemon
    let imageHeight = 150.0
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color(pokemon.types.first!.type.name)
                .opacity(0.4)
                .cornerRadius(14)
                .frame(maxHeight: imageHeight * 0.7)
            
            HStack(alignment: .lastTextBaseline) {
                AsyncImage(url: pokemon.officialArtWork) { image in
                    image
                        .resizable()
                        .frame(width: imageHeight, height: imageHeight)
                        .scaledToFit()
                } placeholder: {
                    ProgressView().progressViewStyle(.circular)
                }
                VStack(alignment: .leading) {
                    Text(pokemon.name.capitalized)
                        .font(.largeTitle)
                    Text("#\(pokemon.id)")
                        .font(.title)
                    HStack {
                        ForEach(pokemon.types) { pokemonType in
                            PokemonTypeTag(pokemonType: pokemonType)
                        }
                    }
                }
                .foregroundColor(.white)
            }
            .padding(.bottom, 5)
        }
    }
}

struct PokemonRow_Previews: PreviewProvider {
    static let pokemon = Pokemon.example
    
    static var previews: some View {
        PokemonRow(pokemon: pokemon)
    }
}
