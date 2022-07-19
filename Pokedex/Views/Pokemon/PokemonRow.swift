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
                localizedName = await getLocalizedName()
            }
    }
    
    func getLocalizedName() async -> String? {
        guard let type = await pokeAPI.pokemonType(named: name) else { return "Error" }
        let availableLanguageCodes = type.names.map { typeName in
            typeName.language.languageCode
        }
        let deviceLanguageCode = Bundle.preferredLocalizations(from: availableLanguageCodes).first!
        let matchingType = type.names.first { typeName in
            typeName.language.languageCode == deviceLanguageCode
        }
        return matchingType?.name
    }
}

struct PokemonRow: View {
    let pokemon: Pokemon
    let imageHeight = 150.0
    
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
                Text(pokemon.name.capitalized)
                    .font(.largeTitle)
                Text("#\(pokemon.id)")
                    .font(.title)
                HStack {
                    ForEach(pokemon.types) { pokemonType in
                        PokemonTypeTag(name: pokemonType.type.name)
                    }
                }
            }
            .foregroundColor(.white)
            .padding()
            Spacer()
        }
        .background {
            pokemon.typeColour
                .opacity(0.4)
                .cornerRadius(14) // TODO: Remove magic numbers
                .frame(maxHeight: imageHeight * 0.7)
                .offset(y: 20)
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
