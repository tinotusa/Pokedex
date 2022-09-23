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
    }
}

// MARK: - Subviews
private extension MoveDetail {
    var pokemonList: some View {
        HStack {
            Text(viewModel.moveInfo[.learnedBy, default: "Error"])
            Spacer()
            if !move.learnedByPokemon.isEmpty {
                NavigationLink {
                    PokemonListView(
                        title: viewModel.localizedMoveName,
                        id: move.id,
                        description: "Pokemon that can learn this move.",
                        pokemonURLS: move.learnedByPokemon.map { $0.url }
                    )
                } label: {
                    ShowMoreButton()
                }
            }
        }
    }
    
    var machinesList: some View {
        HStack {
            Text(viewModel.moveInfo[.machines, default: "Error"])
            Spacer()
            if !move.machines.isEmpty {
                NavigationLink {
                    MachinesListView(moveDetailViewModel: viewModel)
                } label: {
                    ShowMoreButton()
                }
            }
        }
    }
    
    var moveFlavorTextEntires: some View {
        HStack {
            Text(viewModel.moveInfo[.moveFlavourTextEntries, default: "Error"])
            Spacer()
            if !viewModel.filteredMoveFlavorTextEntries .isEmpty {
                NavigationLink {
                    MoveFlavourTextEntriesListView(moveDetailViewModel: viewModel)
                } label: {
                    ShowMoreButton()
                }
            }
        }
    }
    
    var moveDetail: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                HeaderWithID(title: viewModel.localizedMoveName, id: viewModel.moveID)
                    
                Text(viewModel.localizedVerboseEffect)
                
                Divider()
                
                Text(viewModel.localizedShortVerboseEffect)
                
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
                    
                    if move.meta != nil {
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
                    } else {
                        Text("No move metadata.")
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
        NavigationStack {
            MoveDetail(move: .example)
                .environmentObject(ImageCache())
                .environmentObject(SettingsManager())
        }
    }
}
