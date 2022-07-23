//
//  EvolutionsTab.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

struct EvolutionsTab: View {
    private let pokemon: Pokemon
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    var body: some View {
        Text("Evolutions tab")
    }
}

struct EvolutionsTab_Previews: PreviewProvider {
    static var previews: some View {
        EvolutionsTab(pokemon: .example)
    }
}
