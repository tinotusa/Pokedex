//
//  TypeDetail.swift
//  Pokedex
//
//  Created by Tino on 14/9/2022.
//

import SwiftUI

struct TypeDetail: View {
    let type: `Type`
    @StateObject private var viewModel = TypeDetailViewModel()
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        VStack {
            HeaderBar() {
                
            }
            ScrollView(showsIndicators: false) {
            HeaderWithID(title: viewModel.localizedTypeName, id: type.id)
                VStack {
                    switch viewModel.viewState {
                    case . loading:
                        LoadingView()
                            .task {
                                viewModel.loadData(type: type, settings: settingsManager.settings)
                            }
                    case .loaded:
                        VStack(alignment: .leading) {
                            typeInfoGrid
                            
                            Divider()
                            
                            Text("Damage relations")
                                .subHeaderStyle()
                            
                            damageRelationGrid
                        }
                    default:
                        Text("Error loading.")
                    }
                }
            }
        }
        .padding()
        .bodyStyle()
        .foregroundColor(.textColour)
        .backgroundColour()
        .toolbar(.hidden)
    }
}

private extension TypeDetail {
    enum Constants {
        static let gridVerticalSpacing = 15.0
    }
    
    var typeInfoGrid: some View {
        Grid(alignment: .leading, verticalSpacing: Constants.gridVerticalSpacing) {
            ForEach(TypeDetailViewModel.TypeInfoKey.allCases) { typeInfoKey in
                GridRow {
                    Text(typeInfoKey.title)
                        .gridRowTitleStyle()

                    switch typeInfoKey {
                    case .gameIndices: gameIndicesRow
                    case .generation: GenerationTag(name: type.generation.name)
                    case .moveDamageClass: moveDamageClassRow
                    case .pokemon: pokemonRow
                    case .moves: movesRow
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var moveDamageClassRow: some View {
        if type.moveDamageClass != nil {
            MoveDamageClassTag(name: viewModel.typeInfo[.moveDamageClass, default: "Error"])
        } else {
            Text("N/A")
                .foregroundColor(.gray)
        }
    }
    
    var damageRelationGrid: some View {
        Grid(alignment: .leadingFirstTextBaseline, verticalSpacing: Constants.gridVerticalSpacing) {
            ForEach(TypeDetailViewModel.TypeRelationKey.allCases) { typeRelationKey in
                GridRow {
                    Text(typeRelationKey.title)
                        .gridRowTitleStyle()
                    WrappingHStack {
                        let damageRelation = viewModel.damageRelations[typeRelationKey, default: []]
                        if damageRelation.isEmpty {
                            Text("N/A")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(damageRelation, id: \.self) { relation in
                                PokemonTypeTag(namedAPIResource: relation)
                            }
                        }
                    }
                }
            }
        }
    }
    
    var pokemonRow: some View {
        HStack {
            Text(viewModel.typeInfo[.pokemon, default: "Error"])
            
            Spacer()
            if !type.pokemon.isEmpty {
                NavigationLink {
                    PokemonListView(
                        title: viewModel.localizedTypeName,
                        id: type.id,
                        description: "Pokemon with this type.",
                        pokemonURLS: type.pokemon.map { $0.pokemon.url }
                    )
                } label: {
                    ShowMoreButton()
                }
            }
        }
    }
    
    var movesRow: some View {
        HStack {
            Text(viewModel.typeInfo[.moves, default: "Error"])
            
            Spacer()
            if !type.moves.isEmpty {
                NavigationLink {
                    MovesListView(
                        title: viewModel.localizedTypeName,
                        id: type.id,
                        description: "Moves with this type.",
                        moveURLS: type.moves.map { $0.url }
                    )
                } label: {
                    ShowMoreButton()
                }
            }
        }
    }
    
    var gameIndicesRow: some View {
        HStack {
            Text(viewModel.typeInfo[.gameIndices, default: "Error"])
            
            Spacer()
            if !type.gameIndices.isEmpty {
                NavigationLink {
                    Text("Game indices")
                } label: {
                    ShowMoreButton()
                }
            }
        }
    }
}

struct TypeDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TypeDetail(type: .example)
                .environmentObject(ImageCache())
                .environmentObject(SettingsManager())
        }
    }
}
