//
//  MovesTab.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

struct MovesTab: View {
    private let pokemon: Pokemon
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    var body: some View {
        Text("moves tab")
    }
}

struct MovesTab_Previews: PreviewProvider {
    static var previews: some View {
        MovesTab(pokemon: .example)
    }
}
