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
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        VStack(alignment: .leading) {
            headerBar
            
            ScrollView(showsIndicators: false) {
                switch viewModel.viewState {
                case .loading:
                    LoadingView()
                        .task {
                            await viewModel.loadData(ability: ability, settings: settingsManager.settings)
                        }
                case .loaded:
                    VStack(alignment: .leading) {
                        HeaderWithID(title: viewModel.localizedAbilityName, id: ability.id)
                        
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
            PokemonListView(
                title: viewModel.localizedAbilityName,
                id: ability.id,
                description: "Pokemon with this ability.",
                pokemonURLS: ability.pokemon.map { $0.pokemon.url }
            )
            .preferredColorScheme(settingsManager.isDarkMode ? .dark : .light)
        }
        .fullScreenCover(isPresented: $viewModel.showEffectChangesView) {
            AbilityEffectChangesView(viewModel: viewModel)
                .preferredColorScheme(settingsManager.isDarkMode ? .dark : .light)
        }
    }
}

// MARK: Subviews
private extension AbilityDetail {
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
            GenerationTag(name: ability.generation.name)
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
                if !viewModel.effectChanges.isEmpty {
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
            }
        }
    }
}

struct AbilityDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AbilityDetail(ability: .example)
                .environmentObject(ImageCache())
                .environmentObject(SettingsManager())
        }
    }
}
