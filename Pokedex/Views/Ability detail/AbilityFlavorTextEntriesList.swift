//
//  AbilityFlavorTextEntriesList.swift
//  Pokedex
//
//  Created by Tino on 17/9/2022.
//

import SwiftUI

struct AbilityFlavorTextEntriesList: View {
    let title: String
    let id: Int
    let description: LocalizedStringKey
    let entries: [AbilityFlavorText]
    
    @StateObject private var viewModel = AbilityFlavorTextEntriesListViewModel()
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        VStack(alignment: .leading) {
            HeaderBar() {
                
            }
            
            HeaderWithID(title: title, id: id)
            
            Text(description)
            Divider()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    switch viewModel.viewState {
                    case .loading:
                        LoadingView()
                            .task {
                                await viewModel.loadData(entries: entries, settings: settingsManager.settings)
                            }
                    case .loaded:
                        entriesList
                    case .empty:
                        Text("No flavour text entries.")
                    case .error(let error):
                        Text(error.localizedDescription)
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

private extension AbilityFlavorTextEntriesList {
    var entriesList: some View {
        ForEach(entries, id: \.self) { entry in
            VStack(alignment: .leading) {
                HStack {
                    let names = viewModel.getLocalizedVersionName(for: entry.versionGroup.name)
                    ForEach(names, id: \.self) { name in
                        Text(name)
                        if name != names[names.count - 1] {
                            Divider()
                                .frame(maxHeight: 30)
                        }
                    }
                }
                .foregroundColor(.gray)
                Text(entry.flavorText.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression))
            }
        }
    }
}

struct AbilityFlavorTextEntriesList_Previews: PreviewProvider {
    static var previews: some View {
        AbilityFlavorTextEntriesList(
            title: "Some title",
            id: 123,
            description: "Some description",
            entries: []
        )
        .environmentObject(SettingsManager())
    }
}
