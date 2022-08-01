//
//  MoveGridItemView.swift
//  Pokedex
//
//  Created by Tino on 1/8/2022.
//

import SwiftUI

struct MoveGridItemView: View {
    let move: Move
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(move.names.localizedName ?? move.name)
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(.white)
            Spacer()
            HStack {
                PokemonTypeTag(name: move.type.name)
                Spacer()
                Text("PP: \(move.pp)")
                    .font(.title3)
                    .foregroundColor(.textColour)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding()
        .background {
            Rectangle()
                .fill(Color(move.type.name).opacity(0.8))
        }
        .cornerRadius(14)
    }
}

struct MoveGridItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MoveGridItemView(move: .example)
        }
    }
}
