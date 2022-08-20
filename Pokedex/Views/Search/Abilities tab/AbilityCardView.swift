//
//  AbilityCardView.swift
//  Pokedex
//
//  Created by Tino on 20/8/2022.
//

import SwiftUI

struct AbilityCardView: View {
    let ability: Ability
    @Environment(\.appSettings) var appSettings
    @State private var generation: Generation?
    
    var body: some View {
        HStack {
            Text("\(ability.id).")
            
            VStack(alignment: .leading) {
                HStack {
                    Text(localizedAbilityName)
                    Spacer()
                    Text(localizedGenerationName)
                }
                Text(localizedEffectShortEntry)
                    .lineLimit(1)
                    .footerStyle()
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.cardBackgroundColour)
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(.gray.opacity(0.4), lineWidth: 1)
            }
        }
        .bodyStyle()
        .foregroundColor(.textColour)
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
        AbilityCardView(ability: .example)
    }
}
