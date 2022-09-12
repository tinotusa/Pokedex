//
//  PokemonTypeTag.swift
//  Pokedex
//
//  Created by Tino on 1/8/2022.
//

import SwiftUI

/// A small rounded rectangle with the name and colour of the pokemon's type.
struct PokemonTypeTag: View {
    /// The name for the type.
    /// This is also the name of the colour in the asset catalog
    private let name: String
    
    @State private var localizedName: String?
    @State private var type: `Type`?
    @EnvironmentObject private var settingsManager: SettingsManager
    
    // MARK: Initializers
    init(move: Move) {
        self.name = move.type.name
    }
    
    init(pokemonType: PokemonType) {
        self.name = pokemonType.type.name
    }
    
    init(type: `Type`) {
        self.name = type.name
    }
    
    init(namedAPIResource: NamedAPIResource) {
        self.name = namedAPIResource.name
    }
    
    init(name: String) {
        self.name = name
    }
    
    // MARK: Body
    var body: some View {
        Group {
            if let type {
                NavigationLink(value: type) {
                    typePill
                }
            } else {
                ProgressView()
            }
        }
        .task {
            await getType()
        }
    }
}

private extension PokemonTypeTag {
    struct Constants {
        static let cornerRadius = 18.0
    }
    
    var typePill: some View {
        Text(localizedName ?? name.capitalized)
            .lineLimit(1)
            .colouredLabel(colourName: name)
    }
    
    func getType() async {
        type = try? await `Type`.from(name: self.name)
        guard let type else { return }
        localizedName = type.names.localizedName(language: settingsManager.settings.language, default: self.name)
    }
}

struct PokemonTypeTag_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PokemonTypeTag(move: .example)
                .environmentObject(SettingsManager())
        }
    }
}
