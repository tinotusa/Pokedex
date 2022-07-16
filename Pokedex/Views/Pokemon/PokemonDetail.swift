//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

struct RoundedRectangle: Shape {
    let corners: UIRectCorner
    let radius: Double
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

/// The detail view for a pokemon.
struct PokemonDetail: View {
    let pokemon: Pokemon
    
    @Environment(\.dismiss) private var dismiss
    let imageSize = 250.0
    
    var body: some View {
        VStack {
            header
                .padding()

            nameAndNumberHeader
                .padding()
            VStack {
                pokemonImage

                PokemonStats(pokemon: pokemon)
                Spacer()
            }
            .background {
                Color.white
                    .clipShape(RoundedRectangle(corners: [.topLeft, .topRight], radius: 14))
                    .ignoresSafeArea()
                    .padding(.top, 230)
            }
        }
//        .padding()
        .background {
            pokemon.typeColour
                .opacity(0.4)
                .ignoresSafeArea()
        }
        .foregroundColor(.textColour)
        .toolbar(.hidden)
    }
}

// MARK: - Subviews
private extension PokemonDetail {
    var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .scaleEffect(1.5)
                    .bold()
            }
            Spacer()
        }
    }
    
    var nameAndNumberHeader: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(pokemon.name.capitalized)
                    .font(.largeTitle.bold())
                    .textSelection(.enabled)
                HStack {
                    ForEach(pokemon.types) { pokemonType in
                        PokemonTypeTag(pokemonType: pokemonType)
                    }
                }
            }
            Spacer()
            Text("#\(pokemon.id)")
                .font(.largeTitle)
                .fontWeight(.thin)
        }
    }
    
    var pokemonImage: some View {
        AsyncImage(url: pokemon.officialArtWork) { image in
            image
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .scaledToFit()
        } placeholder: {
            ProgressView().progressViewStyle(.circular)
        }
    }
}

struct PokemonDetail_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetail(pokemon: .example)
            .environmentObject(PokeAPI())
    }
}
