//
//  MoveCard.swift
//  Pokedex
//
//  Created by Tino on 20/8/2022.
//

import SwiftUI

struct MoveCard: View {
    let move: Move
    @Environment(\.appSettings) private var appSettings
    @StateObject private var viewModel = MoveCardViewModel()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(viewModel.localizedMoveName)
                        .subHeaderStyle()
                    Spacer()
                    Text(viewModel.moveID)
                        .fontWeight(.ultraLight)
                        .foregroundColor(.gray)
                }
                Text(viewModel.localizedMoveShortEffect)
                    .lineLimit(1)
                    .foregroundColor(.gray)
                HStack {
                    Text(viewModel.localizedDamageClassName)
                        .colouredLabel(colourName: move.damageClass.name)
                    
                    PokemonTypeTag(move: move)
                }
            }
        }
        .bodyStyle()
        .foregroundColor(.textColour)
        .padding(.horizontal)
        .padding(.vertical, 4)
        .card()
        .task {
            viewModel.setUp(move: move, settings: appSettings)
            await viewModel.loadData()
        }
    }
}

struct MoveCard_Previews: PreviewProvider {
    static var previews: some View {
        MoveCard(move: .example)
    }
}
