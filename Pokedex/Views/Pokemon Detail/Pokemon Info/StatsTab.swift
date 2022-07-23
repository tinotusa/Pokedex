//
//  StatsTab.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

struct StatsTab: View {
    private let pokemon: Pokemon
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    var body: some View {
        Text("pokemon stats")
    }
}

struct StatsTab_Previews: PreviewProvider {
    static var previews: some View {
        StatsTab(pokemon: .example)
    }
}
