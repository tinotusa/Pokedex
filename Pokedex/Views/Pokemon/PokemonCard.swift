//
//  PokemonCard.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

struct PokemonCard: View {
    let pokemon: Pokemon
    @StateObject private var viewModel = PokemonCardViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        VStack(spacing: 0) {
            PokemonImage(
                url: pokemon.officialArtWork,
                imageSize: Constants.imageSize
            )
            VStack(alignment: .leading) {
                Text(viewModel.localizedPokemonName)
                    
                HStack {
                    ForEach(pokemon.types, id: \.self) { pokemonType in
                        PokemonTypeTag(pokemonType: pokemonType)
                    }
                    Spacer()
                }
            }
        }
        .overlay(alignment: .topLeading) {
            Text(pokemon.formattedID)
        }
        .padding()
        .bodyStyle()
        .foregroundColor(.textColour)
        
        .background {
            RoundedRectangle(cornerRadius: Constants.backgroundCornerRadius)
                .strokeBorder(pokemon.primaryTypeColour, lineWidth: 2)
                .background(Color.cardBackgroundColour)
        }
        .card(
            cornerRadius: Constants.backgroundCornerRadius,
            shadowOpacity: Constants.shadowOpacity,
            shadowRadius: Constants.shadowRadius,
            shadowX: 0,
            shadowY: 0
        )
        .task {
            viewModel.setUp(pokemon: pokemon, appSettings: settingsManager.settings)
            await viewModel.loadData()
        }
    }
}

private extension PokemonCard {
    enum Constants {
        static let backgroundOpacity = 0.5
        static let backgroundCornerRadius = 30.0
        static let backgroundHeightPercentage = 0.6
        static let imageSize = 150.0
        
        static let shadowRadius = 3.0
        static let shadowOpacity = 0.5
    }
}

struct PokemonRow_Previews: PreviewProvider {
    static let pokemon = Pokemon.example
    
    static var previews: some View {
        PokemonCard(pokemon: pokemon)
            .environmentObject(ImageCache())
            .environmentObject(SettingsManager())
    }
}
