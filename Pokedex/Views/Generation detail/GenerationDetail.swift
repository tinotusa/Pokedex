//
//  GenerationDetail.swift
//  Pokedex
//
//  Created by Tino on 21/9/2022.
//

import SwiftUI

struct GenerationDetail: View {
    let generation: Generation
    @StateObject private var viewModel = GenerationDetailViewModel()
    @EnvironmentObject private var settingsManager: SettingsManager
    private let typesColumns: [GridItem] = [
        .init(.adaptive(minimum: 80))
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HeaderBar {
                
            }
            HeaderWithID(title: viewModel.localizedGenerationName, id: generation.id)
            switch viewModel.viewState {
            case .loading:
                LoadingView()
                    .task {
                        await viewModel.loadData(generation: generation, settings: settingsManager.settings)
                    }
            case .loaded:
                generationInfoGrid
            case .empty:
                NoDataView(text: "No generation data to load.")
            case .error(let error):
                ErrorView(text: error.localizedDescription)
            }
            Spacer()
        }
        .bodyStyle()
        .foregroundColor(.textColour)
        .padding()
        .backgroundColour()
        .toolbar(.hidden)
    }
}

// MARK: Subviews
private extension GenerationDetail {
    var generationInfoGrid: some View {
        ScrollView(showsIndicators: false) {
            Grid(alignment: .topLeading, verticalSpacing: 10) {
                ForEach(GenerationDetailViewModel.GenerationInfo.allCases) { generationInfoKey in
                    GridRow {
                        Text(generationInfoKey.title)
                            .gridRowTitleStyle()
                        switch generationInfoKey {
                        case .moves: movesRow
                        case .abilities: abilitiesRow
                        case .pokemonSpecies: pokemonSpeciesRow
                        case .types: typesRow
                        case .versionGroups: versionGroupRow
                        default: Text(viewModel.generationInfo[generationInfoKey, default: "Error"])
                        }
                    }
                }
            }
        }
    }
    
    var movesRow: some View {
        HStack {
            Text(viewModel.generationInfo[.moves, default: "Error"])
            Spacer()
            if !generation.moves.isEmpty {
                NavigationLink {
                    MovesListView(
                        title: viewModel.localizedGenerationName,
                        id: generation.id,
                        description: "Moves that were introduced in this generation.",
                        moveURLS: generation.moves.map { $0.url }
                    )
                } label: {
                    ShowMoreButton()
                }
            }
        }
    }
    
    var pokemonSpeciesRow: some View {
        HStack {
            Text(viewModel.generationInfo[.pokemonSpecies, default: "Error"])
            Spacer()
            if !generation.pokemonSpecies.isEmpty {
                NavigationLink {
                    PokemonSpeciesListView(
                        title: viewModel.localizedGenerationName,
                        id: generation.id,
                        description: "Pokemon species that were introduced in this generation.",
                        pokemonSpeciesURLS: generation.pokemonSpecies.map { $0.url }
                    )
                } label: {
                    ShowMoreButton()
                }
            }
        }
    }
    
    @ViewBuilder
    var typesRow: some View {
        if generation.types.isEmpty {
            Text("No new types introduced.")
        } else {
            ViewThatFits {
                HStack {
                    ForEach(generation.types, id: \.self) { type in
                        PokemonTypeTag(namedAPIResource: type)
                    }
                }
                LazyVGrid(columns: typesColumns, alignment: .leading) {
                    ForEach(generation.types, id: \.self) { type in
                        PokemonTypeTag(namedAPIResource: type)
                    }
                }
            }
        }
    }
    
    var abilitiesRow: some View {
        HStack {
            Text(viewModel.generationInfo[.abilities, default: "Error"])
            Spacer()
            if !generation.abilities.isEmpty {
                NavigationLink {
                    AbilityListView(
                        title: viewModel.localizedGenerationName,
                        id: generation.id,
                        description: "Abilities introduced in this generation.",
                        abilityURLs: generation.abilities.map { $0.url }
                    )
                } label: {
                    ShowMoreButton()
                }
            }
        }
    }
    
    @ViewBuilder
    var versionGroupRow: some View {
        if generation.versionGroups.isEmpty {
            Text("N/A")
        } else {
            VStack(alignment: .leading) {
                ForEach(viewModel.versionGroups) { versionGroup in
                    let versions = viewModel.versions(withName: versionGroup.name)
                    ViewThatFits(in: .horizontal) {
                        HStack {
                            ForEach(versions) { version in
                                VersionTag(version: version)
                                if version != versions[versions.count - 1] {
                                    Divider()
                                }
                            }
                        }
                        VStack(alignment: .leading) {
                            ForEach(versions) { version in
                                VersionTag(version: version)
                            }
                        }
                    }
                }
            }
        }
        
    }
}

// MARK: - Previews
struct GenerationDetail_Previews: PreviewProvider {
    static var previews: some View {
        GenerationDetail(generation: .exampleGeneration1)
            .environmentObject(SettingsManager())
    }
}
