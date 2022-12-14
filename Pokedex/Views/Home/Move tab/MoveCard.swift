//
//  MoveCard.swift
//  Pokedex
//
//  Created by Tino on 20/8/2022.
//

import SwiftUI

struct MoveCard: View {
    let move: Move
    @EnvironmentObject private var settingsManager: SettingsManager
    @StateObject private var viewModel = MoveCardViewModel()
    
    var body: some View {
        NavigationLink {
            MoveDetail(move: move)
        } label: {
            cardButton
        }
        .task {
            await viewModel.loadData(move: move, settings: settingsManager.settings)
        }
    }
}

private extension MoveCard {
    var cardButton: some View {
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
                    MoveDamageClassTag(name: move.damageClass.name)
                    
                    PokemonTypeTag(move: move)
                }
            }
        }
        .bodyStyle()
        .foregroundColor(.textColour)
        .padding(.horizontal)
        .padding(.vertical, 4)
        .card()
    }
}

struct MoveCard_Previews: PreviewProvider {
    static var previews: some View {
        MoveCard(move: .example)
            .environmentObject(SettingsManager())
    }
}
