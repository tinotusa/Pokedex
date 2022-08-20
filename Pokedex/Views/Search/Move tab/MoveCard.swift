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
            Text("\(move.id).", comment: "The id of the pokemon followed by a fullstop.")
                
            VStack(alignment: .leading) {
                Text(move.names.localizedName(language: appSettings.language, default: move.name.capitalized))
                
                Text(localizedDamageClassName)
                    .footerStyle()
                    .italic()
                
                PokemonTypeTag(name: move.type.name)
            }
            Spacer()
            Grid(alignment: .leading) {
                GridRow {
                    Text("Power", comment: "Grid row title: The power(strength) of the pokemon.")
                    Text("\(move.power ?? 0)")
                }
                GridRow {
                    Text("PP", comment: "Grid row title: PP (Power Points).")
                    Text("\(move.pp)")
                }
            }
        }
        .bodyStyle()
        .foregroundColor(.textColour)
        .padding(.horizontal)
        .padding(.vertical, 4)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(move.type.name).opacity(0.8))
        }
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
