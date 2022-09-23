//
//  GenerationTag.swift
//  Pokedex
//
//  Created by Tino on 11/9/2022.
//

import SwiftUI

struct GenerationTag: View {
    let name: String
    @StateObject private var viewModel = GenerationTagViewModel()
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
                .task {
                    await viewModel.load(name: name, settings: settingsManager.settings)
                }
        case .loaded:
            if let generation = viewModel.generation {
                NavigationLink {
                    GenerationDetail(generation: generation)
                } label: {
                    Text(viewModel.localizedGenerationName)
                        .colouredLabel(colourName: name)
                }
            }
        default:
            Text("Error loading.")
        }
    }
}


struct GenerationTag_Previews: PreviewProvider {
    static var previews: some View {
        GenerationTag(name: "generation-i")
            .environmentObject(SettingsManager())
    }
}

