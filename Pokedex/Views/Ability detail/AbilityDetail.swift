//
//  AbilityDetail.swift
//  Pokedex
//
//  Created by Tino on 25/8/2022.
//

import SwiftUI

@MainActor
final class AbilityDetailViewModel: ObservableObject {
    @Published var ability: Ability!
    @Published var settings: Settings!
    @Published private(set) var generation: Generation?
    
    @Published var setUpCalled = false
    @Published private(set) var isLoading = false
}

extension AbilityDetailViewModel {
    func setUp(ability: Ability, settings: Settings) {
        defer { setUpCalled = true }
        self.ability = ability
        self.settings = settings
    }
    
    func loadData() async {
        if !setUpCalled {
            fatalError("Error Called load data without calling set up.")
        }
        isLoading = true
        defer { isLoading = false }
        generation = try? await Generation.from(name: ability.generation.name)
    }
}

extension AbilityDetailViewModel {
    var localizedAbilityName: String {
        if !setUpCalled { return "Error" }
        return ability.names.localizedName(language: settings.language, default: ability.name)
    }
    
    var abilityID: String {
        if !setUpCalled { return "Error" }
        return String(format: "#%03d", ability.id)
    }
    
    var flavorText: String {
        if !setUpCalled { return "Error" }
        return ability.flavorTextEntries.localizedAbilityFlavorText(language: settings.language, default: "Error")
    }
    
    var isMainSeriesAbility: String {
        if !setUpCalled { return "Error" }
        return ability.isMainSeries ? "Yes" : "No"
    }
    
    var localizedGeneration: String {
        if !setUpCalled { return "Error" }
        guard let generation else {
            print("Error in \(#function). generation is nil.")
            return "Error"
        }
        return generation.names.localizedName(language: settings.language, default: "Error")
    }
    
    var effectChanges: [(versionGroupName: String, effectChange: String)] {
        if !setUpCalled { return [] }
        var changes = [(String, String)]()
        for effect in ability.effectChanges {
            let effectChange = effect.effectEntries.localizedEffectName(language: settings.language, default: "Error")
            changes.append((effect.versionGroup.name, effectChange))
        }
        return changes
    }
    
}

struct AbilityDetail: View {
    let ability: Ability
    @StateObject private var viewModel = AbilityDetailViewModel()
    @Environment(\.appSettings) var appSettings
    
    var body: some View {
        VStack(alignment: .leading) {
            headerBar
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    titleAndID
                    
                    Text(viewModel.flavorText)
                    
                    Divider()
                    
                    Grid(alignment: .leadingFirstTextBaseline, verticalSpacing: 6) {
                        isMainSeries
                        
                        generation
                        
                        pokemon
                        
                        if !viewModel.effectChanges.isEmpty {
                            effectChanges
                        }
                    }
                }
            }
            
        }
        .padding(.horizontal)
        .bodyStyle()
        .foregroundColor(.textColour)
        .toolbar(.hidden)
        .task {
            viewModel.setUp(ability: ability, settings: appSettings)
            await viewModel.loadData()
        }
    }
}

extension AbilityDetail {
    var titleAndID: some View {
        VStack(spacing: 0) {
            HStack {
                Text(viewModel.localizedAbilityName)
                Spacer()
                Text(viewModel.abilityID)
                    .fontWeight(.ultraLight)
            }
            Divider()
        }
        .headerStyle()
    }
    
    var headerBar: some View {
        HeaderBar {
            
        }
    }
    
    var isMainSeries: some View {
        GridRow {
            Text("Main series")
                .gridRowTitleStyle()
            Text(viewModel.isMainSeriesAbility)
        }
    }
    
    var generation: some View {
        GridRow {
            Text("Generation")
                .gridRowTitleStyle()
            Text(viewModel.localizedGeneration)
                .colouredLabel(colourName: ability.generation.name)
        }
    }
    
    var pokemon: some View {
        GridRow {
            Text("Pokemon")
                .gridRowTitleStyle()
            Text("\(ability.pokemon.count)")
        }
    }
    
    var effectChanges: some View {
        GridRow {
            Text("Effect changes")
                .gridRowTitleStyle()
            VStack {
                ForEach(viewModel.effectChanges, id: \.effectChange) { version, effectChange in
                    Text("\(effectChange)\n(\(version))")
                }
            }
        }
    }
}

struct AbilityDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AbilityDetail(ability: .example)
        }
    }
}
