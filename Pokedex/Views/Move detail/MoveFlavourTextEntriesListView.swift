//
//  MoveFlavourTextEntriesListView.swift
//  Pokedex
//
//  Created by Tino on 14/9/2022.
//

import SwiftUI

struct MoveFlavourTextEntriesListView: View {
    @ObservedObject var moveDetailViewModel: MoveDetailViewModel
    @StateObject private var viewModel = MoveFlavourTextEntriesListViewViewModel()
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        VStack {
            PopoverNavigationBar()
            HeaderWithID(title: moveDetailViewModel.localizedMoveName, id: moveDetailViewModel.moveID)
            
            ScrollView(showsIndicators: false) {
                switch viewModel.viewState {
                case .loading:
                    LoadingView()
                        .task {
                            await viewModel.loadData(
                                settings: settingsManager.settings,
                                entries: moveDetailViewModel.filteredMoveFlavorTextEntries
                            )
                        }
                case .loaded:
                    entriesList
                case .empty:
                    Text("No entries")
                case .error(let error):
                    Text(error.localizedDescription)
                }
            }
        }
        .bodyStyle()
        .foregroundColor(.textColour)
        .padding()
        .backgroundColour()
    }
}

private extension MoveFlavourTextEntriesListView {
    var entriesList: some View {
        VStack(alignment: .leading) {
            Text("Move flavour text entries.")
            Divider()
            ForEach(moveDetailViewModel.filteredMoveFlavorTextEntries, id: \.self) { entry in
                Text(viewModel.localizedVersionName(for: entry.versionGroup.name))
                    .foregroundColor(.gray)
                Text(entry.flavorText.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression))
                Divider()
            }
        }
    }
}

struct MoveFlavourTextEntriesListView_Previews: PreviewProvider {
    static var viewModel = {
        let vm = MoveDetailViewModel()
        Task {
            await vm.loadData(move: .example, settings: .default)
        }
        return vm
    }()

    static var previews: some View {
        MoveFlavourTextEntriesListView(moveDetailViewModel: viewModel)
            .environmentObject(SettingsManager())
    }
}
