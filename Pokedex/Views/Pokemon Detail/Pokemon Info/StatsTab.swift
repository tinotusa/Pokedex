//
//  StatsTab.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

struct StatsTab: View {
    @StateObject private var viewModel: StatsTabViewModel
    @EnvironmentObject private var pokeAPI: PokeAPI
    
    init(pokemon: Pokemon) {
        _viewModel = StateObject(wrappedValue: StatsTabViewModel(pokemon: pokemon))
    }
    
    var body: some View {
        VStack {
            Grid(alignment: .leading) {
                hpGridRow
                attackGridRow
                defenseGridRow
            }
        }
        .task {
            await viewModel.setUp(pokeAPI: pokeAPI)
        }
    }
}

private extension StatsTab {
    var hpGridRow: some View {
        GridRow {
            Text(viewModel.hpStatName)
                .foregroundColor(.grayTextColour)
            Text("\(viewModel.hp)")
                .bold()
            ProgressView(value: Double(viewModel.hp), total: Double(viewModel.totalStats))
                .progressViewStyle(.linear)
//                        .tint(.blue) TODO: - change the colour of the bar based on the value given.
        }
    }
    
    var attackGridRow: some View {
        GridRow {
            Text("Attack", comment: "Grid row title: The attack power of the pokemon.")
                .foregroundColor(.grayTextColour)
            Text("\(viewModel.attack)")
                .bold()
            ProgressView(value: Double(viewModel.attack), total: Double(viewModel.totalStats))
                .progressViewStyle(.linear)
        }
    }
    
    var defenseGridRow: some View {
        GridRow {
            Text("Defense", comment: "Grid row title: The defense power of the pokemon.")
                .foregroundColor(.grayTextColour)
            Text("\(viewModel.defense)")
            ProgressView(value: Double(viewModel.defense), total: Double(viewModel.totalStats))
                .progressViewStyle(.linear)
        }
    }
}

struct StatsTab_Previews: PreviewProvider {
    static var previews: some View {
        StatsTab(pokemon: .example)
            .environmentObject(PokeAPI())
    }
}
