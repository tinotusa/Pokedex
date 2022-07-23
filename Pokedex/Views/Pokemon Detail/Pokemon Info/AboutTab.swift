//
//  AboutTab.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

struct AboutTab: View {
    @StateObject private var viewModel: AboutTabViewModel
    @EnvironmentObject private var pokeAPI: PokeAPI
    
    init(pokemon: Pokemon) {
        _viewModel = StateObject(wrappedValue: AboutTabViewModel(pokemon: pokemon))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Grid(alignment: .topLeading, verticalSpacing: 5) {
                GridRow {
                    Text("Species", comment: "Grid row title: The species of the pokemon.")
                        .foregroundColor(.grayTextColour)
                    Text(viewModel.pokemonSeedType)
                        .bold()
                }
                GridRow {
                    Text("Height", comment: "Grid row title: The height of the pokemon.")
                        .foregroundColor(.grayTextColour)
                    Text(Measurement(value: Double(viewModel.pokemonHeight), unit: UnitLength.meters).formatted())
                        .bold()
                }
                GridRow {
                    Text("Weight", comment: "Grid row title: The weight of the pokemon.")
                        .foregroundColor(.grayTextColour)
                    Text(Measurement(value: Double(viewModel.pokemonWeight), unit: UnitMass.kilograms).formatted())
                        .bold()
                }
                GridRow {
                    Text("Abilities", comment: "Grid row title: The default abilities of the pokemon.")
                        .foregroundColor(.grayTextColour)
                    Text(viewModel.pokemonAbilities)
                        .bold()
                }
            }
            
            Text("Breeding", comment: "Title: The breeding information for the pokemon.")
                .font(.title2)
                .fontWeight(.medium)
                .padding(.top, 2)
            
            Grid(alignment: .bottomLeading, verticalSpacing: 5) {
                GridRow {
                    Text("Gender", comment: "Grid row title: The gender percentages for the pokemon (e.g Gender: 85% male 15% female).")
                        .foregroundColor(.grayTextColour)
                    HStack(alignment: .lastTextBaseline) {
                        Text("♂")
                            .font(.title) // TODO: Make this into a modifier
                            .foregroundColor(.blue)
                        Text("\(viewModel.pokemonMaleGenderPercentage.formatted(.percent))")
                            .bold()
                    
                        Text("♀")
                            .font(.title)
                            .foregroundColor(.pink)
                        Text("\(viewModel.pokemonFemaleGenderPercentage.formatted(.percent))")
                            .bold()
                    }
                }
                
                GridRow {
                    Text("Egg groups")
                        .foregroundColor(.grayTextColour)
                    Text(viewModel.eggGroupNames)
                        .bold()
                }
            }
            
            Text("Strong against", comment: "Title: The pokemon types this pokemon is strong against.")
                .font(.title2)
                .fontWeight(.medium) // TODO: Make this into a modifier
                .padding(.vertical, 2)
            
            WrappingHStack {
                ForEach(viewModel.doubleDamageTo, id: \.self) { typeName in
                    Button {
                        
                    } label: {
                        PokemonTypeTag(name: typeName.lowercased())
                    }
                }
            }
            
            Text("Weak against", comment: "Title: The pokemon types this pokemon is weak against.")
                .font(.title2)
                .fontWeight(.medium)
                .padding(.vertical, 2)
            
            WrappingHStack {
                ForEach(viewModel.doubleDamageFrom, id: \.self) { typeName in
                    Button {
                        print("Pressed \(typeName)")
                    } label: {
                        PokemonTypeTag(name: typeName.lowercased())
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .task {
            await viewModel.setUp(pokeAPI: pokeAPI)
        }
    }
}
struct AboutTab_Previews: PreviewProvider {
    static var previews: some View {
        AboutTab(pokemon: .example)
    }
}
