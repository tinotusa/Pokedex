//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

enum InfoTab: String, CaseIterable, Identifiable {
    case about
    case stats
    case evolutions
    case moves
    
    var id: Self { self }
}

/// The detail view for a pokemon.
struct PokemonDetail: View {
    @State private var selectedTab: InfoTab = .about
    @StateObject private var viewModel: PokemonDetailViewModel
    @State private var values = ["fighting", "ground", "flying", "fire", "fighting", "ground", "flying", "fire", "fighting", "ground", "flying", "fire"]
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var pokeAPI: PokeAPI
    
    @Namespace private var namespace
    private let animationID = 1
    private let size = 250.0
    
    init(pokemon: Pokemon) {
        _viewModel = StateObject(wrappedValue: PokemonDetailViewModel(pokemon: pokemon))
    }
    
    var body: some View {
        VStack {
            header
            
            ScrollView(showsIndicators: false) {
                pokemonInfoBar
                    .padding(.horizontal)
                pokemonImage
                VStack {
                    tabHeader
                        .padding(.vertical)
                    
                    switch selectedTab {
                    case .about: aboutTab
                    case .stats: Text("Stats page")
                    case .evolutions: Text("Evolutions page")
                    case .moves: Text("Moves page")
                    }
                }
                .padding()
                .background {
                    Color.white
                        .ignoresSafeArea()
                }
                .clipShape(CustomRoundedRectangle(corners: [.allCorners], radius: 24))
                .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 5)
            }
            .task {
                await viewModel.setUp(pokeAPI: pokeAPI)
            }
            .toolbar(.hidden)
        }
        .background {
            Rectangle()
                .fill(viewModel.pokemonTypeColour.gradient)
                .ignoresSafeArea()
    }
    }
    
    func isSelected(tab: InfoTab) -> Bool {
        selectedTab == tab
    }
}

// MARK: - Subviews
private extension PokemonDetail {
    var aboutTab: some View {
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
                ForEach(values /*viewModel.doubleDamageTo*/, id: \.self) { typeName in
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
                ForEach(values /*viewModel.doubleDamageFrom*/, id: \.self) { typeName in
                    Button {
                        print("Pressed \(typeName)")
                    } label: {
                        PokemonTypeTag(name: typeName.lowercased())
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var tabHeader: some View {
        HStack {
            ForEach(InfoTab.allCases) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack {
                        Text(tab.rawValue.capitalized)
                            .padding(.vertical, 2)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(isSelected(tab: tab) ? .black : .grayTextColour)
                            .background(alignment: .bottom) {
                                if isSelected(tab: tab) {
                                    Rectangle()
                                        .fill(viewModel.pokemonTypeColour)
                                        .frame(height: 2)
                                        .matchedGeometryEffect(id: animationID, in: namespace)
                                }
                            }
                            .animation(.spring(), value: selectedTab)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .contentShape(Rectangle())
                }
            }
        }
    }
    
    var pokemonImage: some View {
        AsyncImage(url: viewModel.pokemonImageURL) { image in
            image
                .resizable()
                .frame(width: size, height: size)
                .scaledToFit()
        } placeholder: {
            ZStack {
                viewModel.pokemonTypeColour
                    .opacity(0.7)
                    .frame(width: size, height: size)
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
    }
    
    @ViewBuilder
    var pokemonInfoBar: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(viewModel.pokemonName)
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Text("#\(viewModel.pokemonID)")
                    .font(.title)
                    .bold()
            }
            HStack {
                ForEach(viewModel.pokemonTypes) { type in
                    PokemonTypeTag(name: type.type.name)
                }
                Spacer()
                Text(viewModel.eggGroupNames)
            }
        }
        .foregroundColor(.textColour)
    }
    
    var header: some View {
        HeaderBar {
            dismiss()
        } content: {
            Text(viewModel.pokemonName)
                .foregroundColor(.textColour)
            Spacer()
            Button {
                // TODO: - might implement later.
            } label: {
                Image(systemName: "heart")
            }
        }
        .padding(.horizontal)
    }
}

struct PokemonDetail_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetail(pokemon: .example)
            .environmentObject(PokeAPI())
    }
}
