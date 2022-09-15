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
        .bodyStyle()
        .foregroundColor(.textColour)
        .backgroundColour()
        .fullScreenCover(isPresented: $viewModel.showMachinesList) {
            MachinesListView(moveDetailViewModel: viewModel)
                .preferredColorScheme(settingsManager.isDarkMode ? .dark : .light)
        }
        .fullScreenCover(isPresented: $viewModel.showPokemonList) {
            PokemonListView(
                title: viewModel.localizedMoveName,
                id: move.id,
                description: "Pokemon that can learn this move.",
                pokemonURLS: move.learnedByPokemon.map { $0.url }
            )
                .preferredColorScheme(settingsManager.isDarkMode ? .dark : .light)
        }
        .fullScreenCover(isPresented: $viewModel.showMoveFlavorTextEntries) {
            MoveFlavourTextEntriesListView(moveDetailViewModel: viewModel)
                .preferredColorScheme(settingsManager.isDarkMode ? .dark : .light)
        }
    }
}

// MARK: - Subviews
private extension MoveDetail {
    var pokemonList: some View {
        ShowMoreButton(
            label: viewModel.moveInfo[.learnedBy, default: "Error"],
            showButton: !move.learnedByPokemon.isEmpty
        ) {
            viewModel.showPokemonList = true
        }
    }
    
    var machinesList: some View {
        ShowMoreButton(
            label: viewModel.moveInfo[.machines, default: "Error"],
            showButton: !move.machines.isEmpty
        ) {
            viewModel.showMachinesList = true
        }
    }
    
    var moveFlavorTextEntires: some View {
        ShowMoreButton(
            label: viewModel.moveInfo[.moveFlavourTextEntries, default: "Error"],
            showButton: !viewModel.filteredMoveFlavorTextEntries.isEmpty
        ) {
            viewModel.showMoveFlavorTextEntries = true
        }
    }
    
    var showDetailButton: some View {
        Button {
            withAnimation {
                viewModel.showLongEffectEntry.toggle()
            }
        } label: {
            Label(
                viewModel.showLongEffectEntry ? "Hide detail" : "Show detail",
                systemImage: viewModel.showLongEffectEntry ? "chevron.up" : "chevron.down"
            )
            .animation(nil, value: viewModel.showLongEffectEntry)
        }
        .foregroundColor(.highlightColour)
    }
    
    var moveDetail: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                HeaderWithID(title: viewModel.localizedMoveName, id: viewModel.moveID)
                    
                Text(viewModel.localizedVerboseEffect(short: true))
                
                showDetailButton
                
                if viewModel.showLongEffectEntry {
                    Text(viewModel.localizedVerboseEffect())
                }
                
                Divider()
                
                Grid(alignment: .leadingFirstTextBaseline, verticalSpacing: Constants.gridVerticalSpacing) {
                    ForEach(MoveDetailViewModel.MoveInfoKey.allCases) { moveInfoKey in
                        GridRow {
                            Text(moveInfoKey.rawValue.localizedCapitalized)
                                .gridRowTitleStyle()
                            
                            switch moveInfoKey {
                            case .type: PokemonTypeTag(name: viewModel.moveInfo[moveInfoKey, default: "Error"])
                            case .moveFlavourTextEntries: moveFlavorTextEntires
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
        }
    }
    
    var headerBar: some View {
        HeaderBar {
            
        }
    }
    
    enum Constants {
        static let gridVerticalSpacing = 6.0
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
