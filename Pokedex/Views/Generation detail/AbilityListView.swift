//
//  AbilityListView.swift
//  Pokedex
//
//  Created by Tino on 22/9/2022.
//

import SwiftUI

struct AbilityListView: View {
    let title: String
    let id: Int
    let description: LocalizedStringKey
    let abilityURLs: [URL]
    
    @StateObject private var viewModel = AbilityListViewViewModel()
    @EnvironmentObject private var settingsManager: SettingsManager

    var body: some View {
        VStack {
            HeaderBar {
                
            }
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    HeaderWithID(title: title, id: id)
                    Text(description)
                    Divider()
                    
                    switch viewModel.viewState {
                    case .loading:
                        LoadingView()
                            .task {
                                await viewModel.loadData(urls: abilityURLs, settings: settingsManager.settings)
                            }
                    case .loaded:
                        abilitiesList
                    case .empty:
                        NoDataView(text: "No abilities to load.")
                    case .error(let error):
                        ErrorView(text: error.localizedDescription)
                    }
                }
            }
        }
        .padding()
        .bodyStyle()
        .foregroundColor(.textColour)
        .backgroundColour()
        .toolbar(.hidden)
    }
}

private extension AbilityListView {
    var abilitiesList: some View {
        LazyVStack(alignment: .leading) {
            ForEach(viewModel.abilities) { ability in
                AbilityCard(ability: ability)
            }
            if viewModel.hasNextPage {
                ProgressView()
                    .task {
                        await viewModel.loadNextPage()
                    }
            }
        }
    }
}

struct AbilityListView_Previews: PreviewProvider {
    static var previews: some View {
        AbilityListView(
            title: "Hello world",
            id: 123,
            description: "howdy there",
            abilityURLs: Generation.example.abilities.map { $0.url }
        )
        .environmentObject(SettingsManager())
    }
}
