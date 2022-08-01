//
//  PokemonTypeTag.swift
//  Pokedex
//
//  Created by Tino on 1/8/2022.
//

import SwiftUI

/// A small rounded rectangle with the name and colour of the pokemon's type.
struct PokemonTypeTag: View {
    let name: String
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
                localizedName = await localizedType()
            }
    }
}

private extension PokemonTypeTag {
    func localizedType() async -> String {
        guard let type = await `Type`.from(name: name) else { return name }
        return type.names.localizedName ?? name
    }
}

struct PokemonTypeTag_Previews: PreviewProvider {
    static var previews: some View {
        PokemonTypeTag(name: "bug")
    }
}
