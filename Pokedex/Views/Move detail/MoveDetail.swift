//
//  MoveDetail.swift
//  Pokedex
//
//  Created by Tino on 24/8/2022.
//

import SwiftUI

struct MoveDetail: View {
    let move: Move
    @Environment(\.appSettings) private var appSettings
    @StateObject private var viewModel = MoveDetailViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            headerBar
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text(viewModel.localizedMoveName)
                            Spacer()
                            Text(viewModel.moveID)
                                .fontWeight(.ultraLight)
                        }
                        .headerStyle()
                        Divider()
                    }
                    Text(viewModel.localizedFlavorText)
                        
                    Divider()
                    
                    Grid(alignment: .leadingFirstTextBaseline, verticalSpacing: Constants.gridVerticalSpacing) {
                        Group {
                            type
                            
                            target
                        }
                        Group {
                            accuracy
                            
                            effectChance
                            
                            powerPoints
                            
                            priority
                            
                            power
                            
                            damageClass
                            
                            effect
                            
                            learnedBy
                            
                            generation
                            
                            machines
                        }
                        
                        Divider()
                        
                        Group {
                            Text("Metadata")
                                .subHeaderStyle()
                            
                            Grid(alignment: .leadingFirstTextBaseline, verticalSpacing: Constants.gridVerticalSpacing) {
                                Group {
                                    ailment
                                    
                                    category
                                    
                                    minHits
                                    
                                    maxHits
                                    
                                    maxTurns
                                    
                                    drain
                                    
                                    healing
                                    
                                    critRate
                                    
                                    ailmentChance
                                    
                                    flinchChance
                                }
                                
                                statChance
                            }
                        }
                    }
                }
                .bodyStyle()
            }
        }
        .padding(.horizontal)
        .toolbar(.hidden)
        .background {
            Color.backgroundColour
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $viewModel.showMoreMachines) {
            MachinesListView(moveDetailViewModel: viewModel)
        }
        .task {
            if !viewModel.viewHasAppeared {
                viewModel.setUp(move: move, settings: appSettings)
                await viewModel.loadData()
                viewModel.viewHasAppeared = true
            }
        }
    }
}

// MARK: - General
private extension MoveDetail {
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
    var type: some View {
        GridRow {
            Text("Type")
                .gridRowTitleStyle()
            PokemonTypeTag(name: move.type.name)
        }
    }
    
    var target: some View {
        GridRow {
            Text("Target")
                .gridRowTitleStyle()
            Text(viewModel.localizedTargetName)
        }
    }
    
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

// MARK: Grid rows
private extension MoveDetail {
    var accuracy: some View {
        GridRow {
            Text("Accuracy")
                .gridRowTitleStyle()
            Text(viewModel.accuracy)
        }
    }
    
    var effectChance: some View {
        GridRow {
            Text("Effect chance")
                .gridRowTitleStyle()
            Text(viewModel.effectChance)
        }
    }
    
    var powerPoints: some View {
        GridRow {
            Text("PP (Power Points)")
                .gridRowTitleStyle()
            Text("\(move.pp)")
        }
    }
    
    var priority: some View {
        GridRow {
            Text("Priority")
                .gridRowTitleStyle()
            Text("\(move.priority)")
        }
    }
    
    var power: some View {
        GridRow {
            Text("Power")
                .gridRowTitleStyle()
            Text(viewModel.power)
        }
    }
    
    var damageClass: some View {
        GridRow {
            Text("Damage class")
                .gridRowTitleStyle()
            Text(viewModel.localizedMoveDamageClassName)
                .colouredLabel(colourName: viewModel.moveDamageClass?.name ?? "none")
        }
    }
    
    var effect: some View {
        GridRow {
            Text("Effect")
                .gridRowTitleStyle()
            Text(viewModel.localizedShortVerboseEffect)
        }
    }
    
    var learnedBy: some View {
        GridRow {
            Text("Learned by")
                .gridRowTitleStyle()
            Text("\(move.learnedByPokemon.count) Pokemon")
        }
    }
    
    var generation: some View {
        GridRow {
            Text("Generation")
                .gridRowTitleStyle()
            Text(viewModel.localizedGenerationName)
                .colouredLabel(colourName: move.generation.name)
        }
    }
    
    var machines: some View {
        GridRow {
            Text("Machines")
                .gridRowTitleStyle()
            HStack {
                Text(viewModel.machinesCount)
                Spacer()
                if viewModel.moveCanBeTaughtByMachines {
                    Button {
                        viewModel.showMoreMachines = true
                    } label: {
                        Text("Show machines")
                    }
                    .foregroundColor(.blue)
                }
            }
        }
    }
}

// MARK: - Previews
struct MoveDetail_Previews: PreviewProvider {
    static var previews: some View {
        MoveDetail(move: .example)
            .environmentObject(ImageCache())
    }
}
