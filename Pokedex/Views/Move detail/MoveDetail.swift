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
        .padding(.horizontal)
        .toolbar(.hidden)
        .background {
            Color.backgroundColour
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $viewModel.showMachinesList) {
            MachinesListView(moveDetailViewModel: viewModel)
        }
        .fullScreenCover(isPresented: $viewModel.showPokemonList) {
            MovePokemonListView(moveDetailViewModel: viewModel)
        }
    }
}

// MARK: - General
private extension MoveDetail {
    var pokemonList: some View {
        HStack {
            Text(viewModel.moveInfo[.learnedBy, default: "Error"])
            Spacer()
            Button(action: viewModel.showLearnedByPokemonView) {
                HStack {
                    Text("List")
                    Image(systemName: "chevron.right")
                }
            }
        }
    }
    
    var machinesList: some View {
        HStack {
            Text(viewModel.moveInfo[.machines, default: "Error"])
            Spacer()
            Button(action: viewModel.showMachinesListView) {
                HStack {
                    Text("List")
                    Image(systemName: "chevron.right")
                }
            }
        }
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
                    
//                    Group {
//                        Text("Metadata")
//                            .subHeaderStyle()
//
//                        Grid(alignment: .leadingFirstTextBaseline, verticalSpacing: Constants.gridVerticalSpacing) {
//                            Group {
//                                ailment
//
//                                category
//
//                                minHits
//
//                                maxHits
//
//                                maxTurns
//
//                                drain
//
//                                healing
//
//                                critRate
//
//                                ailmentChance
//
//                                flinchChance
//                            }
//
//                            statChance
//                        }
//                    }
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

// MARK: Metadata grid rows
private extension MoveDetail {
    var ailment: some View {
        GridRow {
            Text("Ailment")
                .gridRowTitleStyle()
            Text(viewModel.localizedMoveAilmentName)
                .colouredLabel(colourName: move.meta.ailment.name)
        }
    }
    
    var category: some View {
        GridRow {
            Text("Category")
                .gridRowTitleStyle()
            Text(viewModel.moveCategoryName)
        }
    }
    
    var minHits: some View {
        GridRow {
            Text("Min hits")
                .gridRowTitleStyle()
            Text(viewModel.minHits)
        }
    }
    
    var maxHits: some View {
        GridRow {
            Text("Max hits")
                .gridRowTitleStyle()
            Text(viewModel.maxHits)
        }
    }
    
    var maxTurns: some View {
        GridRow {
            Text("Max turns")
                .gridRowTitleStyle()
            Text(viewModel.maxTurns)
        }
    }
    
    var drain: some View {
        GridRow {
            Text("Drain")
                .gridRowTitleStyle()
            Text(viewModel.drain)
        }
    }
    
    var healing: some View {
        GridRow {
            Text("Healing")
                .gridRowTitleStyle()
            Text(viewModel.healing)
        }
    }
    
    var critRate: some View {
        GridRow {
            Text("Crit rate")
                .gridRowTitleStyle()
            Text(viewModel.critRate)
        }
    }
    
    var ailmentChance: some View {
        GridRow {
            Text("Ailment chance")
                .gridRowTitleStyle()
            Text(viewModel.ailmentChance)
        }
    }
    
    var flinchChance: some View {
        GridRow {
            Text("Flinch chance")
                .gridRowTitleStyle()
            Text(viewModel.flinchChance)
        }
    }
    
    var statChance: some View {
        GridRow {
            Text("Stat chance")
                .gridRowTitleStyle()
            Text(viewModel.statChance)
        }
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
