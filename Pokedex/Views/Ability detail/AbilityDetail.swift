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
            }
            
        }
        .padding(.horizontal)
        .bodyStyle()
        .foregroundColor(.textColour)
        .background {
            Color.backgroundColour
                .ignoresSafeArea()
        }
        .toolbar(.hidden)
        .task {
            if viewModel.viewHasApeared { return }
            
            viewModel.setUp(ability: ability, settings: appSettings)
            await viewModel.loadData()
            viewModel.viewHasApeared = true
        }
        .fullScreenCover(isPresented: $viewModel.showingPokemonView) {
            PokemonListView(abilityDetailViewModel: viewModel)
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
            VStack {
                ForEach(viewModel.effectChanges, id: \.effectChange) { version, effectChange in
                    HStack(alignment: .top) {
                        Text(effectChange) +
                        Text(" \(version)")
                            .foregroundColor(.gray)
                    }
                }
            }
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
