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
            ScrollView {
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
                            Grid(alignment: .leading, verticalSpacing: Constants.gridVerticalSpacing) {
                                ForEach(TypeDetailViewModel.TypeInfoKey.allCases) { typeInfoKey in
                                    let keyValue = viewModel.typeInfo[typeInfoKey, default: "Error"]
                                    GridRow {
                                        Text(typeInfoKey.title)
                                            .gridRowTitleStyle()

                                        switch typeInfoKey {
                                        case .gameIndices: gameIndicesRow
                                        case .generation: GenerationTag(name: type.generation.name)
                                        case .moveDamageClass: DamageClassTag(name: keyValue)
                                        case .pokemon: pokemonRow
                                        case .moves: movesRow
                                        }
                                    }
                                }
                            }
                            
                            Divider()
                            
                            Text("Damage relations")
                                .subHeaderStyle()
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
                    default:
                        Text("Error loading.")
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.showPokemonList) {
            PokemonListView(
                title: viewModel.localizedTypeName,
                id: type.id,
                description: "Pokemon with this type.",
                typePokemon: type.pokemon
            )
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
    
    var pokemonRow: some View {
        ShowMoreButton(
            label: viewModel.typeInfo[.pokemon, default: "Error"]
        ) {
            viewModel.showPokemonList = true
        }
    }
    
    var movesRow: some View {
        ShowMoreButton(
            label: viewModel.typeInfo[.moves, default: "Error"],
            action: {}
        )
    }
    
    var gameIndicesRow: some View {
        ShowMoreButton(
            label: viewModel.typeInfo[.gameIndices, default: "Error"],
            action: {}
        )
    }
}

struct TypeDetail_Previews: PreviewProvider {
    static var previews: some View {
        TypeDetail(type: .example)
            .environmentObject(ImageCache())
            .environmentObject(SettingsManager())
    }
}
