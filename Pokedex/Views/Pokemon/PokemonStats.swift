//
//  PokemonStats.swift
//  Pokedex
//
//  Created by Tino on 15/7/2022.
//

import SwiftUI

struct PokemonStats: View {
    let pokemon: Pokemon
    @State private var selectedTab: Tab = .about
    @Namespace private var namespace
    @EnvironmentObject var pokeAPI: PokeAPI
    @State private var pokemonSpecies: PokemonSpecies?
    @State private var abilities = ""
    
    enum Tab: String, CaseIterable, Identifiable {
        var id: Self { self }
        case about, stats, evolutions, moves
    }
    
    private func isSelectedTab(_ tab: Tab) -> Bool {
        tab == selectedTab
    }
    
    var body: some View {
        VStack {
            tabButtons
                .animation(.spring(), value: selectedTab)
            ScrollView(showsIndicators: false) {
                Group {
                    switch selectedTab {
                    case .about: aboutDetails
                    case .stats: statsDetails
                    case .evolutions: evolutionDetails
                    case .moves: movesDetails
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
        .foregroundColor(.black)
        .task {
            pokemonSpecies = await pokeAPI.pokemonSpecies(named: pokemon.name)
            var abilities = [String]()
            for ability in pokemon.abilities {
                abilities.append(ability.ability.name)
            }
            self.abilities = ListFormatter.localizedString(byJoining: abilities)
        }
        
    }
}

// MARK: - Subviews
private extension PokemonStats {
    var tabButtons: some View {
        HStack {
            ForEach(Tab.allCases) { tab in
                VStack {
                    Text(tab.rawValue.capitalized)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .overlay(alignment: .bottom) {
                            if isSelectedTab(tab) {
                                Rectangle().frame(height: 2)
                                    .matchedGeometryEffect(id: "underbar", in: namespace)
                            }
                        }
                }
                .foregroundColor(isSelectedTab(tab) ? pokemon.typeColour : .gray)
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedTab = tab
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    @ViewBuilder
    var aboutDetails: some View {
        VStack(alignment: .leading) {
            if let pokemonSpecies {
                Text(pokemonSpecies.aboutText)
                    .padding(.bottom)
                Grid(alignment: .topLeading, verticalSpacing: 5) {
                    GridRow {
                        Text("Species")
                            .foregroundColor(.gray)
                        Text(pokemonSpecies.genus)
                    }
                    GridRow {
                        Text("Height", comment: "Grid row title: The height of the pokemon.")
                            .foregroundColor(.gray)
                        Text(Measurement<UnitLength>(value: Double(pokemon.height), unit: .decimeters).formatted())
                    }
                    GridRow {
                        Text("Weight", comment: "Grid row title: the weight/mass of the pokemon.")
                            .foregroundColor(.gray)
                        Text(Measurement<UnitMass>(value: Double(pokemon.weight), unit: .kilograms).formatted())
                    }
                    GridRow {
                        Text("Abilities", comment: "Grid row title: The abilities/attack moves of the pokemon.")
                            .foregroundColor(.gray)
                        Button {
                            selectedTab = .moves
                        } label: {
                            Text(abilities)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
                .padding(.bottom)
                
                Text("Breeding", comment: "Title: above the pokemon's breeding information.")
                    .font(.title2.bold())
                    .padding(.bottom)
                Grid(alignment: .bottomLeading) {
                    GridRow {
                        Text("Gender", comment: "Grid row title: The gender of the pokemon")
                            .foregroundColor(.gray)
                        HStack(alignment: .bottom) {
                            Text("♂")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Text("\(pokemonSpecies.maleGenderRate.formatted(.percent))")
                            Text("♀")
                                .font(.title2)
                                .foregroundColor(.pink)
                            Text("\(pokemonSpecies.femaleGenderRate.formatted(.percent))")
                        }
                    }
                    GridRow {
                        Text("Egg groups", comment: "Grid row title: The egg group the pokemon belongs to.")
                            .foregroundColor(.gray)
                        Text(pokemonSpecies.allEggGroups)
                    }
                }
            }
        }
    }
    
    var statsDetails: some View {
        Text("stats details")
    }
    
    var evolutionDetails: some View {
        Text("evoloutions for this pokemon")
    }
    
    var movesDetails: some View {
        Text("moves for this pokemon.")
    }
}

struct PokemonStats_Previews: PreviewProvider {
    static var previews: some View {
        PokemonStats(pokemon: .example)
            .environmentObject(PokeAPI())
    }
}
