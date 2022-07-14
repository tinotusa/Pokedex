//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

/// The detail view for a pokemon.
struct PokemonDetail: View {
    let pokemon: Pokemon
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Button("back") {
                dismiss()
            }
            
            Text("Pokemon detail")
            Text(pokemon.name)
        }
        .toolbar(.hidden)
    }
}

struct PokemonDetail_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetail(pokemon: .example)
    }
}
