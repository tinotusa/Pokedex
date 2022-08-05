//
//  PokemonCard.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

struct PokemonCard: View {
    let pokemon: Pokemon
    let imageSize = 150.0
    @State private var localizedPokemonName = ""
    @State private var typeNames = [String]()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                PokemonImage(url: pokemon.officialArtWork, imageSize: imageSize)
                Spacer()
            }
        
            Text("#\(String(format: "%03d", pokemon.id))")
                .font(.title2)
            Text(localizedPokemonName.capitalized)
                .font(.title)
            
            HStack {
                ForEach(typeNames, id: \.self) { typeName in
                    PokemonTypeTag(name: typeName)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .foregroundColor(.textColour)
        .background(alignment: .top) {
            GeometryReader { proxy in
                Rectangle()
                    .fill(pokemon.primaryTypeColour)
                    .opacity(0.5)
                    .cornerRadius(14) // TODO: Remove magic numbers
                    .frame(height: proxy.size.height * 0.7)
                    .offset(y: proxy.size.height - (proxy.size.height * 0.7))
            }
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
        PokemonCard(pokemon: pokemon)
            .environmentObject(ImageLoader())
    }
}
