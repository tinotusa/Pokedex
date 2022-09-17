//
//  PokemonAboutTab.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

struct PokemonAboutTab: View {
    let pokemon: Pokemon
    @ObservedObject var viewModel: PokemonAboutTabViewModel
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        VStack {
            switch viewModel.viewState {
            case .loading:
                LoadingView()
                    .task {
                        await viewModel.loadData(settings: settingsManager.settings, pokemon: pokemon)
                    }
            case .loaded:
                aboutTabView
            case .error(let error):
                Text(error.localizedDescription)
            case .empty:
                Text("Empty")
            }
        }
        .bodyStyle()
        .foregroundColor(.textColour)
        .backgroundColour()
    }
}

private extension PokemonAboutTab {
    var aboutTabView: some View {
        VStack(alignment: .leading) {
            HeaderWithID(title: viewModel.localizedPokemonName, id: pokemon.id)
            
            Text(viewModel.pokemonDescription)

            Divider()
            Grid(alignment: .topLeading, verticalSpacing: 10) {
                ForEach(PokemonAboutTabViewModel.PokemonInfo.allCases) { pokemonInfoKey in
                    GridRow {
                        Text(pokemonInfoKey.title)
                            .gridRowTitleStyle()
                        switch pokemonInfoKey {
                        case .generation: GenerationTag(name: viewModel.pokemonInfo[.generation, default: "Error"])
                        case .type: types
                        case .abilities: abilitiesList
                        case .eggGroups: eggGroups
                        case .gender: Text(viewModel.genderRatePercentages)
                        case .pokedexEntryNumbers:
                            HStack {
                                Text(viewModel.pokemonInfo[pokemonInfoKey, default: "Error"])
                                Spacer()
                                Button(action: viewModel.showPokedexEntryNumbers) {
                                    HStack {
                                        Text(viewModel.showingPokedexEntryNumbers ? "Less" : "More")
                                        Image(systemName: viewModel.showingPokedexEntryNumbers ? "chevron.up" : "chevron.down")
                                    }
                                    .animation(nil, value: viewModel.showingPokedexEntryNumbers)
                                }
                            }
                            
                        default: Text(viewModel.pokemonInfo[pokemonInfoKey, default: "Error"])
                        }
                    }
                }
            }
            if viewModel.showingPokedexEntryNumbers {
                Divider()
                Text("Pokedex entry numbers")
                    .subHeaderStyle()
                Grid(alignment: .bottomLeading, verticalSpacing: 5) {
                    ForEach(viewModel.pokedexNumbers, id: \.pokedex.id) { entryNumber, pokedex in
                        GridRow {
                            Text(pokedex.names.localizedName(language: settingsManager.settings.language, default: pokedex.name))
                                .gridRowTitleStyle()
                            Text("\(entryNumber)")
                        }
                    }
                }
            }
        }
    }
    
    var abilitiesList: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.abilities, id: \.self) { ability in
                NavigationLink {
                    AbilityDetail(ability: ability)
                } label: {
                    Text(viewModel.localizedAbilityName(ability: ability))
                        .colouredLabel(colourName: pokemon.types.first!.type.name)
                }
            }
        }
    }
    
    var eggGroups: some View {
        HStack {
            ForEach(viewModel.eggGroupNames, id: \.self) { name in
                Text(name)
                if name != viewModel.eggGroupNames.last! {
                    Divider()
                        .frame(maxHeight: 20)
                }
            }
        }
    }
    
    var types: some View {
        HStack {
            ForEach(pokemon.types, id: \.self) { type in
                PokemonTypeTag(pokemonType: type)
            }
        }
    }
}

struct PokemonAboutTab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                PokemonAboutTab(pokemon: .example, viewModel: PokemonAboutTabViewModel())
                    .environmentObject(SettingsManager())
            }
        }
    }
}
