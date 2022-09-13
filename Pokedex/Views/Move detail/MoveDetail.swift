//
//  MoveDetail.swift
//  Pokedex
//
//  Created by Tino on 24/8/2022.
//

import SwiftUI

struct MoveDetail: View {
    let move: Move
    @StateObject private var viewModel = MoveDetailViewModel()
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        VStack(alignment: .leading) {
            headerBar
            switch viewModel.viewState {
            case .loading:
                LoadingView()
                    .task {
                        await viewModel.loadData(move: move, settings: settingsManager.settings)
                    }
            case .loaded:
                moveDetail
            default:
                Text("Error loading.")
            }
            
        }
        .padding()
        .toolbar(.hidden)
        .backgroundColour()
        .fullScreenCover(isPresented: $viewModel.showMachinesList) {
            MachinesListView(moveDetailViewModel: viewModel)
                .preferredColorScheme(settingsManager.isDarkMode ? .dark : .light)
        }
        .fullScreenCover(isPresented: $viewModel.showPokemonList) {
            MovePokemonListView(moveDetailViewModel: viewModel)
                .preferredColorScheme(settingsManager.isDarkMode ? .dark : .light)
        }
    }
}

// MARK: - Subviews
private extension MoveDetail {
    var pokemonList: some View {
        ShowMoreButton(
            label: viewModel.moveInfo[.learnedBy, default: "Error"],
            action: viewModel.showLearnedByPokemonView,
            showButton: !move.learnedByPokemon.isEmpty
        )
    }
    
    var machinesList: some View {
        ShowMoreButton(
            label: viewModel.moveInfo[.machines, default: "Error"],
            action: viewModel.showMachinesListView,
            showButton: !move.machines.isEmpty
        )
    }
    
    var moveDetail: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                HeaderWithID(title: viewModel.localizedMoveName, id: viewModel.moveID)
                    
                Text(viewModel.localizedFlavorText)
                    
                Divider()
                
                Grid(alignment: .leadingFirstTextBaseline, verticalSpacing: Constants.gridVerticalSpacing) {
                    ForEach(MoveDetailViewModel.MoveInfoKey.allCases) { moveInfoKey in
                        GridRow {
                            Text(moveInfoKey.rawValue.localizedCapitalized)
                                .gridRowTitleStyle()
                            switch moveInfoKey {
                            case .type: PokemonTypeTag(name: viewModel.moveInfo[moveInfoKey, default: "Error"])
                            case .damageClass: DamageClassTag(name: viewModel.moveInfo[moveInfoKey, default: "Error"])
                            case .learnedBy: pokemonList
                            case .generation: GenerationTag(name: viewModel.moveInfo[moveInfoKey, default: "Error"])
                            case .machines: machinesList
                            default: Text(viewModel.moveInfo[moveInfoKey, default: "Error"])
                            }
                            
                        }
                    }
                    
                    Divider()
                    
                    ForEach(MoveDetailViewModel.MoveMetaInfoKey.allCases) { metaInfoKey in
                        GridRow {
                            Text(metaInfoKey.rawValue.localizedCapitalized)
                                .gridRowTitleStyle()
                            
                            switch metaInfoKey {
                            case .ailment:
                                Text(viewModel.moveMetaInfo[.ailment, default: "Error"])
                                    .colouredLabel(colourName: viewModel.moveMetaInfo[.ailment, default: "Error"])
                            default: Text(viewModel.moveMetaInfo[metaInfoKey, default: "Error"])
                            }
                        }
                    }
                }
            }
            .bodyStyle()
        }
    }
    
    var headerBar: some View {
        HeaderBar {
            
        }
    }
    
    enum Constants {
        static let gridVerticalSpacing = 6.0
        static let maxMachines = 5
    }
}

// MARK: - Previews
struct MoveDetail_Previews: PreviewProvider {
    static var previews: some View {
        MoveDetail(move: .example)
            .environmentObject(ImageCache())
            .environmentObject(SettingsManager())
    }
}
