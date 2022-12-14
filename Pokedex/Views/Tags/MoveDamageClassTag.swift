//
//  MoveDamageClassTag.swift
//  Pokedex
//
//  Created by Tino on 11/9/2022.
//

import SwiftUI

struct MoveDamageClassTag: View {
    let name: String
    @StateObject private var viewModel = MoveDamageClassTagViewModel()
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        switch viewModel.viewState {
        case .loading:
            LoadingView()
                .task {
                    await viewModel.load(name: name, settings: settingsManager.settings)
                }
        case .loaded:
            if let damageClass = viewModel.moveDamageClass {
                NavigationLink {
                    MoveDamageClassDetail(moveDamageClass: damageClass)
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
        MoveDamageClassTag(name: "physical")
            .environmentObject(SettingsManager())
    }
}
