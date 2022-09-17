//
//  DamageClassTag.swift
//  Pokedex
//
//  Created by Tino on 11/9/2022.
//

import SwiftUI

struct DamageClassTag: View {
    let name: String
    @StateObject private var viewModel = DamageClassTagViewModel()
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        switch viewModel.viewState {
        case .loading:
            LoadingView()
                .task {
                    await viewModel.load(name: name, settings: settingsManager.settings)
                }
        case .loaded:
            if let damageClass = viewModel.damageClass {
                NavigationLink {
                    Text("Damage class detail here: \(damageClass.name)")
                } label: {
                    Text(viewModel.localizedDamageClassName)
                        .colouredLabel(colourName: name)
                }
            }
        default:
            Text("Error loading.")
        }
    }
}

struct DamageClassTag_Previews: PreviewProvider {
    static var previews: some View {
        DamageClassTag(name: "physical")
            .environmentObject(SettingsManager())
    }
}
