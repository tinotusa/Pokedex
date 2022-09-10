//
//  PokemonStatsTab.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI
import Charts

struct PokemonStatsTab: View {
    let pokemon: Pokemon
    @StateObject private var viewModel = PokemonStatsTabViewModel()
    
    var body: some View {
        Group {
            if !viewModel.viewHasAppeared {
                LoadingView()
            } else {
                statsTabView
            }
        }
        .foregroundColor(.textColour)
        .task {
            if !viewModel.viewHasAppeared {
                viewModel.setUp(pokemon: pokemon)
                await viewModel.loadData()
                viewModel.viewHasAppeared = true
            }
        }
    }
}

private extension PokemonStatsTab {
    var hpGridRow: some View {
        gridRow(
            title: viewModel.hpStatName,
            value: Double(viewModel.hp),
            total: Double(viewModel.totalStats)
        )
    }
    
    var attackGridRow: some View {
        gridRow(
            title: viewModel.attackStatName,
            value: Double(viewModel.attack),
            total: Double(viewModel.totalStats)
        )
    }
    
    var defenseGridRow: some View {
        gridRow(
            title: viewModel.defenseStatName,
            value: Double(viewModel.defense),
            total: Double(viewModel.totalStats)
        )
    }
    
    var specialAttackGridRow: some View {
        gridRow(
            title: viewModel.specialAttackStatName,
            value: Double(viewModel.specialAttack),
            total: Double(viewModel.totalStats)
        )
    }
    
    var specialDefenseGridRow: some View {
        gridRow(
            title: viewModel.specialDefenseStatName,
            value: Double(viewModel.specialDefense),
            total: Double(viewModel.totalStats)
        )
    }
    
    var speedGridRow: some View {
        gridRow(
            title: viewModel.speedStatName,
            value: Double(viewModel.speed),
            total: Double(viewModel.totalStats)
        )
    }
    
    var totalGridRow: some View {
        gridRow(
            title: "Total",
            value: Double(viewModel.totalStats)
        )
    }
}

private extension PokemonStatsTab {
    var statsTabView: some View {
        VStack(alignment: .leading) {
            Chart(viewModel.valuePerStat) {
                BarMark(
                    x: .value("Stat", $0.value),
                    y: .value("Name", $0.name)
                    
                )
                .foregroundStyle(by: .value("Colour", $0.name))
            }
            .chartForegroundStyleScale([
                viewModel.hpStatName: Color("hp"),
                viewModel.attackStatName: Color("attack"),
                viewModel.defenseStatName: Color("defense"),
                viewModel.specialAttackStatName: Color("specialAttack"),
                viewModel.specialDefenseStatName: Color("specialDefense"),
                viewModel.speedStatName: Color("speed")
            ])
            .chartLegend(.hidden)
            .frame(minHeight: 300)
            
            Text("Strong against", comment: "Title: The pokemon types this pokemon is strong against.")
                .subHeaderStyle()
            
            if viewModel.doubleDamageTo.isEmpty {
                Text("Not strong against any type.")
                    .bold()
            } else {
                WrappingHStack {
                    ForEach(viewModel.doubleDamageTo, id: \.self) { type in
                        PokemonTypeTag(type: type)
                    }
                }
            }
            
            Text("Weak against", comment: "Title: The pokemon types this pokemon is weak against.")
                .subHeaderStyle()
            
            WrappingHStack {
                ForEach(viewModel.doubleDamageFrom, id: \.self) { type in
                    PokemonTypeTag(type: type)
                }
            }
        }
    }
    
    func gridRow(title: String, value: Double, total: Double? = nil) -> some View {
        GridRow {
            Text(LocalizedStringKey(title), comment: "Grid row title: The title for the stat.")
                .foregroundColor(.grayTextColour)
            Text("\(value.formatted(.number))")
                .bold()
            if let total {
                ProgressView(value: value * 3, total: total)
                    .progressViewStyle(.linear)
                    .tint(value * 3 > total / 2 ? .green : .red)
                    
            }
        }
    }
}

struct PokemonStatsTab_Previews: PreviewProvider {
    static var previews: some View {
        PokemonStatsTab(pokemon: .example)
    }
}
