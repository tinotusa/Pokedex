//
//  MoveCard.swift
//  Pokedex
//
//  Created by Tino on 20/8/2022.
//

import SwiftUI

struct MoveCard: View {
    let move: Move
    @Environment(\.appSettings) var appSettings
    @State private var moveDamageClass: MoveDamageClass?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(move.names.localizedName(language: appSettings.language, default: move.name.capitalized))
                        .subHeaderStyle()
                    Spacer()
                    Text(String(format: "#%03d", move.id))
                        .fontWeight(.ultraLight)
                        .foregroundColor(.gray)
                }
                Text(move.effectEntries.first!.shortEffect)
                    .lineLimit(1)
                    .foregroundColor(.gray)
                HStack {
                    Text(localizedDamageClassName)
                        .colouredLabel(colourName: move.damageClass.name)
                    
                    PokemonTypeTag(name: move.type.name)
                }
            }
        }
        .bodyStyle()
        .foregroundColor(.textColour)
        .padding(.horizontal)
        .padding(.vertical, 4)
        .card()
        .task {
            await getMoveDamageClass()
        }
    }
}

private extension MoveCard {
    func getMoveDamageClass() async {
        moveDamageClass = try? await MoveDamageClass.from(name: move.damageClass.name)
    }
    
    var localizedDamageClassName: String {
        guard let moveDamageClass else { return "Error" }
        return moveDamageClass.names
            .localizedName(
                language: appSettings.language,
                default: move.damageClass.name
            )
            .capitalized
    }
}

struct MoveCard_Previews: PreviewProvider {
    static var previews: some View {
        MoveCard(move: .example)
    }
}
