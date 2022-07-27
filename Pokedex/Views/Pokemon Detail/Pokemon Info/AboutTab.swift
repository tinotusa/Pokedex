//
//  AboutTab.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

struct AboutTab: View {
    @StateObject private var viewModel: AboutTabViewModel

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
                    if viewModel.pokemonFemaleGenderPercentage < 0 {
                        Text("No gender")
                            .bold()
                    } else {
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
                }
                
                GridRow {
                    Text("Egg groups")
                        .foregroundColor(.grayTextColour)
                    Text(viewModel.eggGroupNames)
                        .bold()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .task {
            await viewModel.setUp()
        }
    }
}
struct AboutTab_Previews: PreviewProvider {
    static var previews: some View {
        AboutTab(pokemon: .example)
    }
}
