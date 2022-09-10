//
//  AbilityDetail.swift
//  Pokedex
//
//  Created by Tino on 25/8/2022.
//

import SwiftUI

struct AbilityDetail: View {
    let ability: Ability
    @StateObject private var viewModel = AbilityDetailViewModel()
    @Environment(\.appSettings) var appSettings
    
    var body: some View {
        VStack(alignment: .leading) {
            headerBar
            
            ScrollView(showsIndicators: false) {
                switch viewModel.viewState {
                case .loading:
                    LoadingView()
                        .task {
                            await viewModel.loadData(ability: ability, settings: appSettings)
                        }
                case .loaded:
                    VStack(alignment: .leading) {
                        titleAndID
                        
                        Text(viewModel.shortFlavorText)
                        
                        Divider()
                        
                        Text(viewModel.flavorText)
                        
                        Divider()
                        
                        Grid(alignment: .leadingFirstTextBaseline, verticalSpacing: 6) {
                            isMainSeries
                            
                            generation
                            
                            pokemon
                            
                            if !viewModel.effectChanges.isEmpty {
                                effectChanges
                            }
                        }
                    }
                case .error(let error):
                    Text(error.localizedDescription)
                case .empty:
                    Text("Failed to load data.")
                }
                
            }
        }
        .padding(.horizontal)
        .bodyStyle()
        .foregroundColor(.textColour)
        .backgroundColour()
        .toolbar(.hidden)
        .fullScreenCover(isPresented: $viewModel.showingPokemonView) {
            AbilityPokemonListView(abilityDetailViewModel: viewModel)
        }
        .fullScreenCover(isPresented: $viewModel.showEffectChangesView) {
            AbilityEffectChangesView(viewModel: viewModel)
        }
    }
}

// MARK: Subviews
private extension AbilityDetail {
    var titleAndID: some View {
        VStack(spacing: 0) {
            HStack {
                Text(viewModel.localizedAbilityName)
                Spacer()
                Text(viewModel.abilityID)
                    .fontWeight(.ultraLight)
            }
            Divider()
        }
        .headerStyle()
    }
    
    var headerBar: some View {
        HeaderBar {
            
        }
    }
    
    var isMainSeries: some View {
        GridRow {
            Text("Main series")
                .gridRowTitleStyle()
            Text(viewModel.isMainSeriesAbility)
        }
    }
    
    var generation: some View {
        GridRow {
            Text("Generation")
                .gridRowTitleStyle()
            Text(viewModel.localizedGeneration)
                .colouredLabel(colourName: ability.generation.name)
        }
    }
    
    var pokemon: some View {
        GridRow {
            Text("Pokemon")
                .gridRowTitleStyle()
            HStack {
                Text("\(ability.pokemon.count)")
                Spacer()
                Button {
                    viewModel.showingPokemonView = true
                } label: {
                    Text("Show pokemon")
                }
                .foregroundColor(.blue)
            }
        }
    }
    
    var effectChanges: some View {
        GridRow {
            Text("Effect changes")
                .gridRowTitleStyle()
            HStack {
                Text("\(viewModel.effectChanges.count)")
                Spacer()
                Button {
                    viewModel.showEffectChangesView = true
                } label: {
                    if viewModel.effectChanges.count == 1 {
                        Text("Show change")
                    } else {
                        Text("Show changes")
                    }
                }
                .foregroundColor(.blue)
            }
//            VStack {
//                ForEach(viewModel.effectChanges, id: \.effectChange) { version, effectChange in
//                    HStack(alignment: .top) {
//                        Text(effectChange) +
//                        Text(" \(version)")
//                            .foregroundColor(.gray)
//                    }
//                }
//            }
        }
    }
}

struct AbilityDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AbilityDetail(ability: .example)
                .environmentObject(ImageCache())
        }
    }
}
