//
//  StatsTab.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI
import Charts

struct StatsTab: View {
    @StateObject private var viewModel: StatsTabViewModel
    
    init(pokemon: Pokemon) {
        _viewModel = StateObject(wrappedValue: StatsTabViewModel(pokemon: pokemon))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Chart(viewModel.valuePerStat) {
                BarMark(
                    x: .value("Stat", $0.value),
                    y: .value("Name", $0.name)
                    
                )
                .foregroundStyle(by: .value("Colour", $0.name))
            }
            .chartForegroundStyleScale([
                "HP": Color("hp"),
                "Attack": Color("attack"),
                "Defense": Color("defense"),
                "Sp. Attack": Color("specialAttack"),
                "Sp. Defense": Color("specialDefense"),
                "Speed": Color("speed")
            ])
            .frame(minHeight: 300)
            
            Text("Strong against", comment: "Title: The pokemon types this pokemon is strong against.")
                .font(.title2)
                .fontWeight(.medium) // TODO: Make this into a modifier
                .padding(.vertical, 2)
            
            if  viewModel.doubleDamageTo.isEmpty {
                Text("Not strong against any type.")
                    .bold()
            } else {
                WrappingHStack {
                    ForEach(viewModel.doubleDamageTo, id: \.self) { type in
                        NavigationLink(value: type) {
                            PokemonTypeTag(name: type.name)
                        }
                    }
                }
            }
            
            Text("Weak against", comment: "Title: The pokemon types this pokemon is weak against.")
                .font(.title2)
                .fontWeight(.medium)
                .padding(.vertical, 2)
            
            WrappingHStack {
                ForEach(viewModel.doubleDamageFrom, id: \.self) { type in
                    NavigationLink(value: type) {
                        PokemonTypeTag(name: type.name)
                    }
                }
            }
        }
        .navigationDestination(for: `Type`.self) { type in
            Text("Looking at: \(type.name)")
        }
        .task {
            await viewModel.setUp()
        }
    }
}

private extension StatsTab {
    var hpGridRow: some View {
        gridRow(
            title: viewModel.hpStatName,
            value: Double(viewModel.hp),
            total: Double(viewModel.totalStats)
        )
    }
    
    var attackGridRow: some View {
        gridRow(
            title: "Attack",
            value: Double(viewModel.attack),
            total: Double(viewModel.totalStats)
        )
    }
    
    var defenseGridRow: some View {
        gridRow(
            title: "Defense",
            value: Double(viewModel.defense),
            total: Double(viewModel.totalStats)
        )
    }
    
    var specialAttackGridRow: some View {
        gridRow(
            title: "Sp. Attack",
            value: Double(viewModel.specialAttack),
            total: Double(viewModel.totalStats)
        )
    }
    
    var specialDefenseGridRow: some View {
        gridRow(
            title: "Sp. Defense",
            value: Double(viewModel.specialDefense),
            total: Double(viewModel.totalStats)
        )
    }
    
    var speedGridRow: some View {
        gridRow(
            title: "Speed",
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

private extension StatsTab {
    func gridRow(title: String, value: Double, total: Double? = nil) -> some View {
        GridRow {
            Text(title)
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

struct StatsTab_Previews: PreviewProvider {
    static var previews: some View {
        StatsTab(pokemon: .example)
    }
}
