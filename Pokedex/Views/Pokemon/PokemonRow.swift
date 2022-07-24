//
//  PokemonRow.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

/// A small rounded rectangle with the name and colour of the pokemon's type.
struct PokemonTypeTag: View {
    let name: String
    @EnvironmentObject var pokeAPI: PokeAPI
    @State private var localizedName: String?
    init(name: String) {
        self.name = name
    }
    
    var body: some View {
        Text(localizedName ?? name.capitalized)
            .padding(.horizontal)
            .background(Color(name))
            .cornerRadius(14)
            .foregroundColor(.textColour)
            .task {
                
            }
    }
}

struct PokemonRow: View {
    let pokemon: Pokemon
    let imageHeight = 150.0
    @State private var localizedPokemonName = ""
    @State private var typeNames = [String]()
    var body: some View {
        HStack(alignment: .bottom) {
            AsyncImage(url: pokemon.officialArtWork) { image in
                image
                    .resizable()
                    .frame(width: imageHeight, height: imageHeight)
                    .scaledToFit()
            } placeholder: {
                ProgressView().progressViewStyle(.circular)
            }
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
                .frame(maxHeight: imageHeight * 0.7)
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
