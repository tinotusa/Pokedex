//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

@main
struct PokedexApp: App {
    @StateObject var pokeAPI = PokeAPI()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pokeAPI)
        }
    }
}
