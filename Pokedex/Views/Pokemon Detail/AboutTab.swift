//
//  AboutTab.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

struct LoadingView: View {
    var text: LocalizedStringKey = "Loading"
    
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
            Text(text)
            Spacer()
        }
        .bodyStyle()
        .foregroundColor(.textColour)
    }
}

struct AboutTab: View {
    let pokemon: Pokemon
    @StateObject private var viewModel = AboutTabViewModel()
    @Environment(\.appSettings) var appSettings
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else {
                aboutTabView
            }
        }
        .foregroundColor(.textColour)
        .task {
            viewModel.setUp(settings: appSettings, pokemon: pokemon)
            await viewModel.loadData()
        }
    }
}

extension AboutTab {
    @ViewBuilder
    var nameRow: some View {
        HStack {
            Text(viewModel.localizedPokemonName(language: appSettings.language))
            Spacer()
            Text("#\(String(format: "%03d", viewModel.pokemonID))")
                .fontWeight(.ultraLight)
        }
        .headerStyle()
    }
    
    @ViewBuilder
    func gridRow(title: String, value: String) -> some View {
        GridRow {
            Text(title)
                .foregroundColor(.grayTextColour)
            Text(value)
        }
    }
    
    @ViewBuilder
    func gridRow(title: LocalizedStringKey, value: String, comment: StaticString? = nil) -> some View {
        GridRow {
            Text(title, comment: comment)
                .foregroundColor(.grayTextColour)
            Text(value)
        }
    }
    
    @ViewBuilder
    func gridRow<Content: View>(
        title: LocalizedStringKey,
        @ViewBuilder content: () -> Content,
        comment: StaticString? = nil
    ) -> some View {
        GridRow {
            Text(title, comment: comment)
                .foregroundColor(.grayTextColour)
            content()
        }
    }
    
    var aboutTabView: some View {
        VStack(alignment: .leading) {
            nameRow
            
            Text(viewModel.pokemonDescription)
                .bodyStyle()
            Divider()
            Grid(alignment: .topLeading, verticalSpacing: 10) {
                gridRow(title: "Generation") {
                    Text(viewModel.localizedGenerationName)
                        .colouredLabel(colourName: viewModel.generationName)
                }
                gridRow(title: "Type") {
                    HStack {
                        ForEach(pokemon.types, id: \.self) { pokemonType in
                            PokemonTypeTag(name: pokemonType.type.name)
                        }
                    }
                }
                gridRow(title: "Egg groups") {
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
                gridRow(title: "Height") { Text(Measurement(value: viewModel.pokemonHeight, unit: UnitLength.meters).formatted()) }
                gridRow(title: "Weight") { Text(Measurement(value: viewModel.pokemonWeight, unit: UnitMass.kilograms).formatted()) }
                gridRow(title: "Gender") {
                    if viewModel.pokemonFemaleGenderPercentage <= 0.0 {
                        Text("No gender")
                            .bold()
                    } else {
                        HStack(alignment: .lastTextBaseline) {
                            Text("♂")
                                .foregroundColor(.blue)
                            Text("\(viewModel.pokemonMaleGenderPercentage.formatted(.percent))")
                            Text("♀")
                                .foregroundColor(.pink)
                            Text("\(viewModel.pokemonFemaleGenderPercentage.formatted(.percent))")
                        }
                    }
                }
                Group {
                    gridRow(title: "Genus", value: viewModel.pokemonSeedType)
                    gridRow(title: "Capture rate", value: "\(viewModel.pokemonSpecies?.captureRate ?? 0)")
                    gridRow(title: "Base happiness", value: "\(viewModel.pokemonSpecies?.baseHappiness ?? 0)")
                    gridRow(title: "Growth rate", value: viewModel.localizedGrowthRateName)
                    if viewModel.pokemonHasHabitat {
                        gridRow(title: "Habitat", value: viewModel.localizedHabitatName)
                    }
                    gridRow(title: "Legendary", value: "\(viewModel.pokemonSpecies?.isLegendary ?? false ? "Yes" : "No")")
                    gridRow(title: "Mythical", value: "\(viewModel.pokemonSpecies?.isMythical ?? false ? "Yes" : "No")")
                }
            }
            Divider()
            Text("Pokedex entry numbers")
                .subHeaderStyle()
            Grid(alignment: .bottomLeading, verticalSpacing: 5) {
                ForEach(viewModel.pokedexNumbers, id: \.pokedex.name) { entryNumber, pokedex in
                    gridRow(
                        title: pokedex.names.localizedName(language: appSettings.language, default: pokedex.name),
                        value: "\(entryNumber)"
                    )
                }
            }
        }
    }
}

struct AboutTab_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(showsIndicators: false) {
            AboutTab(pokemon: .example)
        }
    }
}
