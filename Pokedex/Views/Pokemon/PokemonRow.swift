//
//  PokemonRow.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

struct PokemonRow: View {
    let pokemon: Pokemon
    let imageSize = 150.0
    @State private var localizedPokemonName = ""
    @State private var typeNames = [String]()
    
    var body: some View {
        HStack(alignment: .bottom) {
            PokemonImage(url: pokemon.officialArtWork, imageSize: imageSize)
    
            VStack(alignment: .leading) {
                Text(localizedPokemonName.capitalized)
                    .font(.largeTitle)
                Text("#\(pokemon.id)")
                    .font(.title)
                HStack {
                    ForEach(typeNames, id: \.self) { typeName in
                        PokemonTypeTag(name: typeName)
                    }
                }
            }
            .foregroundColor(.white)
            .padding()
            Spacer()
        }
        .background {
            Rectangle()
                .fill(pokemon.primaryTypeColour.gradient)
                .opacity(0.75)
                .cornerRadius(14) // TODO: Remove magic numbers
                .frame(maxHeight: imageSize * 0.7)
                .offset(y: 20)
        }
        .task {
            localizedPokemonName = await pokemon.localizedName()
            typeNames = pokemon.getTypes()
        }
    }
}

struct PokemonRow_Previews: PreviewProvider {
    static let pokemon = Pokemon.example
    
    static var previews: some View {
        PokemonRow(pokemon: pokemon)
            .environmentObject(PokeAPI())
    }
}
