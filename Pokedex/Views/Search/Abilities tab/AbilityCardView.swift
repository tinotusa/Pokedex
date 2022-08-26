//
//  AbilityCardView.swift
//  Pokedex
//
//  Created by Tino on 20/8/2022.
//

import SwiftUI

struct CardView: ViewModifier {
    var cornerRadius: Double
    var shadowOpacity: Double
    var shadowRadius: Double
    var shadowX: Double
    var shadowY: Double
    
    func body(content: Content) -> some View {
        content
            .background(.white)
            .cornerRadius(cornerRadius)
            .shadow(
                color: .black.opacity(shadowOpacity),
                radius: shadowRadius,
                x: shadowX,
                y: shadowY
            )
    }
}

extension View {
    func card(
        cornerRadius: Double = 14.0,
        shadowOpacity: Double = 0.2,
        shadowRadius: Double = 2.0,
        shadowX: Double = 0.0,
        shadowY: Double = 2.0
    ) -> some View {
        modifier(
            CardView(
                cornerRadius: cornerRadius,
                shadowOpacity: shadowOpacity,
                shadowRadius: shadowRadius,
                shadowX: shadowX,
                shadowY: shadowY
            )
        )
    }
}

struct AbilityCardView: View {
    let ability: Ability
    @Environment(\.appSettings) var appSettings
    @State private var generation: Generation?
    
    var body: some View {
        HStack {
            
            
            VStack(alignment: .leading) {
                HStack {
                    Text(localizedAbilityName)
                        .subHeaderStyle()
                    Text("\(String(format: "#%03d", ability.id)).")
                        .fontWeight(.ultraLight)
                        .foregroundColor(.gray)
                    
                    Spacer()
                        Text(localizedGenerationName)
                        .foregroundColor(.gray)
                }
                Text(localizedEffectShortEntry)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .bodyStyle()
        .foregroundColor(.textColour)
        .card()
        .task {
            await getGeneration()
        }
    }
}

private extension AbilityCardView {
    var localizedAbilityName: String {
        ability.names.localizedName(
            language: appSettings.language,
            default: ability.name
        )
    }
    
    var localizedGenerationName: String {
        guard let generation else { return "Error" }
        return generation.names.localizedName(
            language: appSettings.language,
            default: generation.name
        )
    }
    
    var localizedEffectShortEntry: String {
        let availableLanguageCodes = ability.effectEntries.map { effect in
            effect.language.name
        }
        let deviceLanaguageCode = Bundle.preferredLocalizations(from: availableLanguageCodes, forPreferences: nil).first!
        let matchingEffectEntry = ability.effectEntries.first { effect in
            effect.language.name == ((appSettings.language != nil) ? appSettings.language!.name : deviceLanaguageCode)
        }
        if let matchingEffectEntry {
            return matchingEffectEntry.shortEffect
        }
        return "Error"
    }
    
    func getGeneration() async {
        guard let generation = try? await Generation.from(name: ability.generation.name) else {
            print("Error in \(#function). Failed to get Generation.")
            return
        }
        self.generation = generation
    }
}

struct AbilityCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.backgroundColour
            AbilityCardView(ability: .example)
        }
    }
}
