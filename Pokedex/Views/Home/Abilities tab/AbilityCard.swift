//
//  AbilityCard.swift
//  Pokedex
//
//  Created by Tino on 20/8/2022.
//

import SwiftUI

struct AbilityCard: View {
    let ability: Ability
    @EnvironmentObject private var settingsManager: SettingsManager
    @StateObject private var viewModel = AbilityCardViewModel()
    
    var body: some View {
        switch viewModel.viewState {
        case .loading:
            LoadingView()
                .task {
                    await viewModel.loadData(ability: ability, settings: settingsManager.settings)
                }
        case .loaded:
            abilityCard
        default:
            Text("Error loading view.")
        }   
    }
}

private extension AbilityCard {
    var abilityCard: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(viewModel.localizedAbilityName)
                        .subHeaderStyle()
                    Text("\(String(format: "#%03d", ability.id)).")
                        .fontWeight(.ultraLight)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    Text(viewModel.localizedGenerationName)
                        .foregroundColor(.gray)
                }
                Text(viewModel.localizedEffectShortEntry)
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
    }
}
struct AbilityCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.backgroundColour
            AbilityCard(ability: .example)
                .environmentObject(SettingsManager())
        }
    }
}
