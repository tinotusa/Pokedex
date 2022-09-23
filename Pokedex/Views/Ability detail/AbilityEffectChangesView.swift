//
//  AbilityEffectChangesView.swift
//  Pokedex
//
//  Created by Tino on 4/9/2022.
//

import SwiftUI

struct AbilityEffectChangesView: View {
    let title: String
    let id: Int
    let description: LocalizedStringKey
    let effectChanges: [AbilityEffectChange]

    @StateObject private var viewModel = AbilityEffectChangesViewViewModel()
    @EnvironmentObject private var settingsManager: SettingsManager
    var body: some View {
        VStack(alignment: .leading) {
            HeaderBar() {
                
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
                                await viewModel.loadData(abilityEffectChanges: effectChanges, settings: settingsManager.settings)
                            }
                    case .loaded:
                        effectChangesGrid
                    case .empty:
                        NoDataView(text: "No ability effect chagnes to load.")
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

private extension AbilityEffectChangesView {
    var effectChangesGrid: some View {
        Grid(alignment: .leadingFirstTextBaseline, verticalSpacing: 6) {
            GridRow(alignment: .center) {
                if effectChanges.count > 1 {
                    Text("Games")
                } else {
                    Text("Game")
                }
                Text("Change")
            }
            .fontWeight(.regular)
            
            ForEach(effectChanges, id: \.self) { effectChange in
                GridRow {
                    let names = viewModel.localizedVersionGroupName(for: effectChange.versionGroup.name)
                    ViewThatFits {
                        HStack {
                            ForEach(names, id: \.self) { name in
                                Text(name)
                            }
                            .foregroundColor(.gray)
                        }
                        VStack {
                            ForEach(names, id: \.self) { name in
                                Text(name)
                            }
                        }
                    }
                    Text(viewModel.localizedEffectEntry(for: effectChange.effectEntries))
                }
            }
        }
    }
}

struct AbilityEffectChangesView_Previews: PreviewProvider {
    static var viewModel = {
        let vm = AbilityDetailViewModel()
        Task {
            await vm.loadData(ability: .example, settings: .default)
        }
        return vm
    }()
    
    static var previews: some View {
        AbilityEffectChangesView(
            title: "Some title",
            id: 123,
            description: "Test description",
            effectChanges: Ability.example.effectChanges
        )
        .environmentObject(SettingsManager())
    }
}
