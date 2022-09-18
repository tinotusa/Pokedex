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
                            ForEach(AbilityDetailViewModel.AbilityInfo.allCases) { abilityInfoKey in
                                GridRow {
                                    Text(abilityInfoKey.title)
                                        .gridRowTitleStyle()
                                    switch abilityInfoKey {
                                    case .generation: GenerationTag(name: viewModel.abilityInfo[.generation, default: "Error"])
                                    case .effectChanges: effectChanges
                                    case .flavorTextEntries: flavorTextEntriesRow
                                    case .pokemon: pokemon
                                    default: Text(viewModel.abilityInfo[abilityInfoKey, default: "Error"])
                                    }
                                }
                            }
                        }
                    }
                case .error(let error):
                    ErrorView(text: error.localizedDescription)
                case .empty:
                    NoDataView(text: "Ability not found.")
                }
                
            }
        }
        .padding(.horizontal)
        .bodyStyle()
        .foregroundColor(.textColour)
        .backgroundColour()
        .toolbar(.hidden)
    }
}

// MARK: - Subviews
private extension AbilityDetail {
    var headerBar: some View {
        HeaderBar {
            
        }
    }
    
    var pokemon: some View {
        HStack {
            Text(viewModel.abilityInfo[.pokemon, default: "Error"])
            Spacer()
            if !ability.pokemon.isEmpty {
                NavigationLink {
                    PokemonListView(
                        title: viewModel.localizedAbilityName,
                        id: ability.id,
                        description: "Pokemon with this ability.",
                        pokemonURLS: ability.pokemon.map { $0.pokemon.url }
                    )
                } label: {
                    ShowMoreButton()
                }
            }
        }
    }
    
    var flavorTextEntriesRow: some View {
        HStack {
            Text(viewModel.abilityInfo[.flavorTextEntries, default: "Error"])
            Spacer()
            if !viewModel.localizedFlavorTextEntries.isEmpty {
                NavigationLink {
                    AbilityFlavorTextEntriesList(
                        title: viewModel.localizedAbilityName,
                        id: ability.id,
                        description: "Flavour text entries for this ability.",
                        entries: viewModel.localizedFlavorTextEntries
                    )
                } label: {
                    ShowMoreButton()
                }
            }
        }
    }
    
    var effectChanges: some View {
        HStack {
            Text("\(viewModel.effectChanges.count)")
            Spacer()
            if !viewModel.effectChanges.isEmpty {
                NavigationLink {
                    AbilityEffectChangesView(viewModel: viewModel)
                } label: {
                    ShowMoreButton()
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
